// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'pictureobject.dart';
//
//
// //Panel for photo list view
// class ListPanel extends StatefulWidget {
//   const ListPanel({Key? key}) : super(key: key);
//
//   @override
//   _ListPanelState createState() => _ListPanelState();
// }
//
// class _ListPanelState extends State<ListPanel> {
//   @override
//   Widget listPanel(PictureObj) {
//     return Center(
//       child: Card(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             const ListTile(
//               title: Text(''),
//               subtitle: Text('Upload Date: ' 'Size: '),
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: <Widget>[
//                 IconButton(
//                   icon: const Icon(Icons.favorite),
//                   onPressed: () {/* ... */},
//                 ),
//                 const SizedBox(width: 8),
//                 IconButton(
//                   icon: const Icon(Icons.more_vert),
//                   onPressed: () {/* ... */},
//                 ),
//                 const SizedBox(width: 8),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }