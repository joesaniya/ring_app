import 'package:flutter/material.dart';
import 'package:phone_call_app/modal/notification_serviice.dart';
import 'package:phone_call_app/view/calling_screen.dart';

class CallLogList extends StatelessWidget {
  String contact;
  String time;
  IconData icon;
  Color iconColor;
  CallLogList(
      {required this.contact,
      required this.time,
      required this.icon,
      required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CallingScreen(
                    phoneno: contact,
                  )),
        );
        NotificationHelper.showNotification(
          "Meeting Joined",
          "You have joined the meeting:",
        );
      },
      leading: Icon(icon, color: iconColor),
      title: Text(contact),
      subtitle: Text(time),
      trailing: Icon(Icons.info_outline),
    );
    /* return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                Icon(icon, color: iconColor),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    Text('India')
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.info_outline)
        ],
      ),
    );
  */
  }
}
