import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:monimba_app/constants.dart';
import 'package:sizer/sizer.dart';

class NotifBodyScreen extends StatefulWidget {
  const NotifBodyScreen({super.key});

  @override
  State<NotifBodyScreen> createState() => _NotifBodyScreenState();
}

class _NotifBodyScreenState extends State<NotifBodyScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            // Category Tabs
          _buildCategoryTabs(),
          // Notification List
          Expanded(child: _buildNotificationList()),
          ],
        ),
      );
  }



  Widget _buildCategoryTabs() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildCategoryTab('Toutes', isSelected: true),
          SizedBox(width: 2.w,),
          _buildCategoryTab('Non Lus'),
          SizedBox(width: 2.w,),
          _buildCategoryTab('Lus'),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(String label, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        // Add logic to handle tab selection if needed
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
        decoration: BoxDecoration(
          color: isSelected ? kBtnsColor.withOpacity(.1) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? kBtnsColor: Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationList() {
    // Sample data for the notifications
    final notifications = [
      {
        'profileImage': 'https://media.istockphoto.com/id/1364105164/fr/photo/hologramme-tête-humaine-apprentissage-profond-et-intelligence-artificielle-contexte-abstrait.jpg?b=1&s=612x612&w=0&k=20&c=k2-26bhZ_Aws3UVKjgO4Z7vJ_FCwTNonGXzzz2Q5a8g=',
        'title': 'What is Lorem Ipsum?',
        'description':
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
        'time': '8 min',
      },
      {
        'profileImage': 'https://media.istockphoto.com/id/1364105164/fr/photo/hologramme-tête-humaine-apprentissage-profond-et-intelligence-artificielle-contexte-abstrait.jpg?b=1&s=612x612&w=0&k=20&c=k2-26bhZ_Aws3UVKjgO4Z7vJ_FCwTNonGXzzz2Q5a8g=',
        'title': 'What is Lorem Ipsum?',
        'description':
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
        'time': '38 min',
      },
      // Add more notifications here...
    ];

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationCard(
          profileImage: notification['profileImage']!,
          title: notification['title']!,
          description: notification['description']!,
          time: notification['time']!,
          // actionButton: notification['actionButton'],
        );
      },
    );
  }

  Widget _buildNotificationCard({
    required String profileImage,
    required String title,
    required String description,
    required String time,
    String? actionButton,
  }) {
    return Container(
      padding: EdgeInsets.all(2.w),
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Image
          CircleAvatar(
            radius: 6.w,
            backgroundImage: NetworkImage(profileImage),
          ),
          SizedBox(width: 3.w),

          // Notification Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Optional Action Button
          // if (actionButton != null)
          //   TextButton(
          //     onPressed: () {},
          //     child: Text(actionButton),
          //     style: TextButton.styleFrom(
          //       padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          //       primary: Colors.blue,
          //       side: const BorderSide(color: Colors.blue),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}