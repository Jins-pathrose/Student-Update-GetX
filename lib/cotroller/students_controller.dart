
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:students_getx/database/models.dart';

class StudentContoller extends GetxController {
  List<Studentupdate> students = [];
  List<Studentupdate> get StudentsList => students;
  RxString selectedimage = ''.obs;
  RxString searchtext = ''.obs;

  getImage() async {
    final picker = ImagePicker();
    final pickedimage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedimage != null) {
      selectedimage.value = pickedimage.path.toString();
    }
  }

  search(String value) {
    searchtext = value.obs;
  }
}
