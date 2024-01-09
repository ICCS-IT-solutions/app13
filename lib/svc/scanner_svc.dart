import 'dart:io';
import 'dart:typed_data';
//import "dart:io";
import 'package:logger/logger.dart';
import "package:cunning_document_scanner/cunning_document_scanner.dart";

class ScannerService
{
    List<File>? imageFiles;
    List<String>? imagesPath;
    Uint8List? imageData;
    static Uint8List? imageBytes;
    Future<List<File>> ScanImage() async
    {
        imagesPath = await CunningDocumentScanner.getPictures(true);
        imageFiles = []; //This ensures that the list of image files returned to the bloc is always new, thus helping avoid duplicates
        //For each image in the list of images
        for (var imageEntry in imagesPath!)
        {
            imageFiles!.add(File(imageEntry));
            Logger().i(File(imageEntry));
        }
        return imageFiles!;
    }
}