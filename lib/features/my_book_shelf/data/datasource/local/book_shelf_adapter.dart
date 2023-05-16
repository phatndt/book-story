import 'package:book_story/features/my_book_shelf/data/model/book_shelf_model.dart';
import 'package:hive/hive.dart';

class BookShelfAdapter extends TypeAdapter<BookShelfModel> {
  @override
  final typeId = 0;

  @override
  BookShelfModel read(BinaryReader reader) {
    return BookShelfModel(reader.read(), reader.read(), reader.read(), reader.read(), reader.read(), reader.read());
  }

  @override
  void write(BinaryWriter writer, BookShelfModel obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.booksList);
    writer.write(obj.color);
    writer.write(obj.createDate);
    writer.write(obj.isDelete);
  }
}
