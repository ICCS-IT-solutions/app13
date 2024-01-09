import 'dart:io';
import 'dart:typed_data';

import 'package:app13/bloc/scannerbloc_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() 
{
    runApp(MyApp());
}

ThemeData appTheme = ThemeData(
    primarySwatch: Colors.blue,
    useMaterial3: false,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
);

class MyApp extends StatefulWidget
{
    final scannerBloc = ScannerBloc();

    MyApp({super.key});

    @override
    State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> 
{ 
    List<File>? imageFiles;
    
    Uint8List? imageData;
    

    @override 
    Widget build(BuildContext context)
    {
        var imageBoxWidth = MediaQuery.of(context).size.width - 100;
        var imageBoxHeight = MediaQuery.of(context).size.height - 130;
        return MaterialApp(
            theme: appTheme,
            title: 'Flutter Demo',
            home: Scaffold(
                appBar: AppBar(
                    title: const Text('Flutter - document scan test'),
                ),
                body: BlocBuilder(
                    bloc: widget.scannerBloc,
                    builder: (context, state) 
                    {
                        if (state is ScannerBlocSuccess)
                        {
                            for(var element in state.capturedImageData)
                            {
                                imageFiles ??= []; //Create a new list if one does not yet exist, then add each element returned from the service via the bloc.
                                imageFiles!.add(element);
                            }
                            return Column(
                                children: [
                                    Row(
                                        mainAxisAlignment:  MainAxisAlignment.center,
                                        children: [SizedBox(width: imageBoxWidth, height: imageBoxHeight, child: _buildImageList(context, imageFiles!))]
                                    ),
                                    ElevatedButton(
                                      onPressed: () => widget.scannerBloc.add(OnScan()),
                                      child: const Text("Scan Image"),
                                    ),
                                ]
                            );
                        }
                        else if(state is ScannerBlocCaptureInProgress)
                        {
                            return const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:[
                                  CircularProgressIndicator(),
                                  SizedBox(height:10),
                                  Text("Capture in progress...")
                                ]
                              )
                            );
                        }
                        else
                        {
                            return Column(
                                children: [
                                    Row(
                                        mainAxisAlignment:  MainAxisAlignment.center,
                                        children: [
                                            SizedBox(width:imageBoxWidth,height:imageBoxHeight, child: const Center(child: Text("Click scan to capture an image")))
                                        ]
                                    ),
                                    ElevatedButton(
                                        onPressed: () => widget.scannerBloc.add(OnScan()),
                                        child: const Text("Scan Image"),
                                    ),
                                ]
                            );
                        }
                    }
                ),
            )
        );
    }

    Widget _buildImageList(BuildContext context, List<File> imageFiles)
    {
        if(imageFiles.isEmpty)
        {
            return const Center(child: Text("No images captured"));
        }
        else
        {
            return ListView.builder(
                itemCount: imageFiles.length,
                itemBuilder: (context, index)
                {
                    return Image.file(imageFiles[index], width: MediaQuery.of(context).size.width - 150, height: MediaQuery.of(context).size.height - 150, fit: BoxFit.scaleDown);
                }
            );
        }
    }
}