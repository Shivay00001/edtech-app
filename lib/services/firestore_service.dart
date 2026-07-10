import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get all available courses
  Stream<List<Course>> getCourses() {
    return _db.collection('courses').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Course.fromFirestore(doc)).toList());
  }

  // Get a single course
  Stream<Course> getCourse(String courseId) {
    return _db.collection('courses').doc(courseId).snapshots().map((doc) => Course.fromFirestore(doc));
  }

  // Get lessons for a course
  Stream<List<Lesson>> getLessonsByCourse(String courseId) {
    return _db
        .collection('courses')
        .doc(courseId)
        .collection('lessons')
        .orderBy('order')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Lesson.fromFirestore(doc)).toList());
  }

  // Get courses user is enrolled in
  Stream<List<Course>> getUserEnrolledCourses(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('enrollments')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Course> courses = [];
      for (var doc in snapshot.docs) {
        final courseId = doc.data()['courseId'];
        if (courseId != null) {
          final courseDoc = await _db.collection('courses').doc(courseId).get();
          if (courseDoc.exists) {
            courses.add(Course.fromFirestore(courseDoc));
          }
        }
      }
      return courses;
    });
  }

  // Update progress for a lesson
  Future<void> updateLessonProgress(String uid, String courseId, String lessonId, bool completed) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('enrollments')
        .doc(courseId)
        .collection('progress')
        .doc(lessonId)
        .set({'completed': completed}, SetOptions(merge: true));
  }

  // Get overall course progress (0.0 to 1.0)
  Stream<double> getCourseProgress(String uid, String courseId, int totalLessons) {
    if (totalLessons == 0) return Stream.value(0.0);
    
    return _db
        .collection('users')
        .doc(uid)
        .collection('enrollments')
        .doc(courseId)
        .collection('progress')
        .where('completed', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.length / totalLessons;
    });
  }
}
