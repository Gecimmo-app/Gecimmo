import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  
  for (var file in files) {
    String content = file.readAsStringSync();
    String newContent = content;
    
    // Replace theme background variables
    newContent = newContent.replaceAll('0xFFF4F6FB', '0xFFEFF6FF');
    newContent = newContent.replaceAll('0xFFF8FAFC', '0xFFEFF6FF');
    newContent = newContent.replaceAll('0xFFF1F5F9', '0xFFEFF6FF');
    newContent = newContent.replaceAll('0xFFF4F7FC', '0xFFEFF6FF');
    newContent = newContent.replaceAll('0xFFF5F7FA', '0xFFEFF6FF');
    
    // Replace backgroundColor: Colors.white, in page files
    if (file.path.endsWith('_page.dart') || file.path.contains('Dashbordprincpa')) {
      newContent = newContent.replaceAll('backgroundColor: Colors.white,', 'backgroundColor: const Color(0xFFEFF6FF),');
    }
    
    if (content != newContent) {
      file.writeAsStringSync(newContent);
      print('Updated ' + file.path);
    }
  }
}

