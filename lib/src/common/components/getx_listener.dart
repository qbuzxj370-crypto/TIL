import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetxListener<T> extends StatefulWidget {
  final Rx<T> stream;
  final Widget child;
  final Function(T) listen;
  final Function()? initCall;
  const GetxListener({
    super.key,
    this.initCall,
    required this.stream,
    required this.listen,
    required this.child,
  });

  @override
  State<GetxListener<T>> createState() => _GetxListenerState<T>();
}

class _GetxListenerState<T> extends State<GetxListener<T>> {
  late final Worker _worker; 
  
  @override
  void initState() {
    super.initState();   
    
    _worker = ever<T>(widget.stream, widget.listen);

    if (widget.initCall != null) {
      widget.initCall!();
    }
  }

  @override
  void dispose() {
    _worker.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
