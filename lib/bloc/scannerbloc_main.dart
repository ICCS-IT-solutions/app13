import 'dart:io';

import 'package:app13/svc/scanner_svc.dart';
import 'package:bloc/bloc.dart';

class ScannerBloc extends Bloc<ScannerBlocEvent, ScannerBlocState> 
{   
    //In C# this would be: ScannerService scannerService = new() or var scannerService = new ScannerService();
    //What's interesting to note is the similarity: dart resembles C# and JScript languages, with some noticeable diffs
    ScannerService scannerService = ScannerService();
    ScannerBloc() : super(ScannerBlocState())
    {
        on<Init> ((event, emit) async => emit(ScannerBlocInitial()));
        on<OnScan>((event, emit) async
        {
            emit(ScannerBlocCaptureInProgress());
            var imageFiles = await scannerService.ScanImage();
            if(imageFiles.isNotEmpty)
            {
                emit (ScannerBlocSuccess(successMsg: "Image captured", capturedImageData: imageFiles));
            }
            else
            {
                emit(ScannerBlocFailure(errorMsg: "No images captured"));
            }
        });
    }
}

class ScannerBlocEvent
{
    
}

class Init extends ScannerBlocEvent
{

}

class OnScan extends ScannerBlocEvent
{

}

//End event section. Todo: move into its own file when it gets too large.
class ScannerBlocState
{
    final String? responseMsg;
    final List<File>? imageData;
    final bool isBusy;

    //Use named args rather than pos args for the constructors, as it's easier to work with.
    ScannerBlocState({this.responseMsg, this.imageData, this.isBusy = false});
}

class ScannerBlocInitial extends ScannerBlocState
{
    //Initial state - nothing much to do here
    ScannerBlocInitial() : super(isBusy: false);
}

class ScannerBlocCaptureInProgress extends ScannerBlocState
{
    //Capture an image
    ScannerBlocCaptureInProgress() : super(isBusy: true);
}

class ScannerBlocSuccess extends ScannerBlocState 
{
    final String successMsg;
    final List<File> capturedImageData;
    //Successful
    ScannerBlocSuccess({required this.successMsg, required this.capturedImageData}) : super(imageData: capturedImageData, isBusy: false, responseMsg: successMsg);
}
class ScannerBlocUserCancelled extends ScannerBlocState
{
    final String cancelledMsg;
    final List<File> capturedImageData;

    ScannerBlocUserCancelled({required this.cancelledMsg, required this.capturedImageData}) : super(imageData: capturedImageData, isBusy: false, responseMsg: cancelledMsg);
}
class ScannerBlocFailure extends ScannerBlocState
{     
    final String errorMsg;
    //Failure occurred, or user cancelled.
    ScannerBlocFailure({required this.errorMsg}) : super(responseMsg: errorMsg, isBusy: false);
}
//End state section. Todo: move into its own file when it gets too large.