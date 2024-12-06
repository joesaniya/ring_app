import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:phone_call_app/controller/contacts_provider.dart';
import 'package:provider/provider.dart';

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // title: Text("Contacts"),
        actions: [
          Icon(
            Icons.more_vert,
            color: Colors.black,
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Consumer<ContactProvider>(
        builder: (context, contactProvider, child) {
          if (contactProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (!contactProvider.permissionGranted) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  contactProvider.checkPermission();
                },
                child: Text("Grant Permission"),
              ),
            );
          }

          // Display contacts
          return Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contacts',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 29,
                      fontWeight: FontWeight.w900),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text(
                  '${contactProvider.contacts.length} Contacts',
                  style: TextStyle(
                      color: Colors.black26,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: contactProvider.contacts.length,
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: Colors.black12,
                      );
                    },
                    itemBuilder: (context, index) {
                      log('img:${contactProvider.contacts[index].photo}');
                      return Container(
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(width: 1, color: Colors.red)),
                              child: Center(
                                child: Text(
                                  contactProvider.contacts[index].displayName
                                          .isNotEmpty
                                      ? contactProvider
                                          .contacts[index].displayName[0]
                                          .toUpperCase()
                                      : '',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(contactProvider
                                    .contacts[index].displayName),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Text(contactProvider
                                        .contacts[index].phones.isNotEmpty
                                    ? contactProvider
                                        .contacts[index].phones[0].number
                                    : 'No phone number'),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
