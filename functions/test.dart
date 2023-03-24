// import 'package:filter_list/filter_list.dart';
// import 'package:flutter/material.dart';
//
// class EnneTest extends StatelessWidget {
//   const EnneTest({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         title: const Text('enne.io'),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: BackButton(
//           onPressed: () =>
//               Navigator.of(context, rootNavigator: true).pop(context),
//         ),
//       ),
//       body: Stack(
//         children: const [
//           BackgroundTestUI(),
//           EnneTestFilter(),
//         ],
//       ),
//     );
//   }
// }
//
// // Background Widget
// class BackgroundTestUI extends StatelessWidget {
//   const BackgroundTestUI({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         decoration: const BoxDecoration(
//             image: DecorationImage(
//                 image: AssetImage('assets/img/enne-blue-blank.jpg'),
//                 fit: BoxFit.cover)));
//   }
// }
//
// // filterlist for Test
//
// class EnneTestFilter extends StatelessWidget {
//   const EnneTestFilter({Key? key, this.selectedUserList}) : super(key: key);
//   final List<User>? selectedUserList = userList;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FilterListWidget<User>(
//         listData: userList,
//         selectedListData: selectedUserList,
//         onApplyButtonClick: (list) {
// // do something with list ..
//         },
//         choiceChipLabel: (item) {
//           /// Used to display text on chip
//           return item!.name;
//         },
//         validateSelectedItem: (list, val) {
//           ///identify if item is selected or not
//           return list!.contains(val);
//         },
//         onItemSearch: (user, query) {
//           /// When search query change in search bar then this method will be called
// ////// Check if items contains query
//           return user.name!.toLowerCase().contains(query.toLowerCase());
//         },
//       ),
//     );
//   }
// }
//
// class User {
//   final String? name;
//   final String? avatar;
//   User({this.name, this.avatar});
// }
//
// List<User> userList = [
//   User(name: "Jon", avatar: ""),
//   User(name: "Lindsey ", avatar: ""),
//   User(name: "Valarie ", avatar: ""),
//   User(name: "Elyse ", avatar: ""),
//   User(name: "Ethel ", avatar: ""),
//   User(name: "Emelyan ", avatar: ""),
//   User(name: "Catherine ", avatar: ""),
//   User(name: "Stepanida", avatar: ""),
//   User(name: "Carolina ", avatar: ""),
//   User(name: "Nail", avatar: ""),
//   User(name: "Kamil ", avatar: ""),
//   User(name: "Mariana ", avatar: ""),
//   User(name: "Katerina ", avatar: ""),
// ];
