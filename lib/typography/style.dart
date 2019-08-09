import 'package:flutter/material.dart';

import './palette.dart';

// Misc notes

// // horizontal app padding = 12.0
// // expression preview profile photo height and width = 36.0


class JuntoStyles {
  // Global Stles
  static const horizontalPadding = EdgeInsets.symmetric(horizontal: 10);

  // Styles for app bar
  static const appbarTitle = TextStyle(
      color: JuntoPalette.juntoSleek,
      fontSize: 17,
      letterSpacing: .5,
      fontWeight: FontWeight.w700);

  static const perspectiveTitle =
      TextStyle(color: JuntoPalette.juntoGrey, fontWeight: FontWeight.w700);

  // Styles for creation templates
  static const lotusExpressionType = 
      TextStyle(fontSize: 17, color: JuntoPalette.juntoGrey, fontWeight: FontWeight.w700, letterSpacing: 1.1,); 

  static const lotusAddChannels = 
      TextStyle(fontWeight: FontWeight.w700);

  static const lotusCreate = 
      TextStyle(fontWeight: FontWeight.w700);
  
  // Longform styles 
  static const lotusLongformTitle = 
      TextStyle(fontSize: 17.0, fontWeight: FontWeight.w700, color: JuntoPalette.juntoGrey);

  static const lotusLongformBody =
      TextStyle(height: 1.25, fontSize: 17.0, fontWeight: FontWeight.w600, color: JuntoPalette.juntoGrey); 


  // Styles for expression preview

  static const expressionPreviewName =
      TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700, color: JuntoPalette.juntoGrey);

  static const expressionPreviewHandle =
      TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: JuntoPalette.juntoGrey);      

  static const expressionPreviewTime = 
      TextStyle(fontSize: 10, color: Colors.grey,fontWeight: FontWeight.w600);

  static const expressionPreviewChannel = 
      TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: JuntoPalette.juntoSleek);
      
  // // longform preview
  static const longformTitle = 
      TextStyle(fontSize: 17.0, fontWeight: FontWeight.w700, color: JuntoPalette.juntoGrey); 

  static const longformBody = 
      TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: JuntoPalette.juntoGrey);
  
  // // photo preview
  static const photoCaption = 
      TextStyle(fontSize: 14, fontWeight: FontWeight.w500);

}


