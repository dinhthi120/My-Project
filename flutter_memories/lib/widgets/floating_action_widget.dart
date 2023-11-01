import 'package:flutter/material.dart';
import 'package:flutter_memories_dailyjournal/pages/calendar_diary.dart';
import 'package:flutter_memories_dailyjournal/pages/create_diary.dart';
import 'package:flutter_memories_dailyjournal/pages/image_gallery.dart';

class FloatingButtonWidget extends StatelessWidget {
  const FloatingButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: MediaQuery.of(context).size.width,
      bottom: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CalendarDiary()));
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(10),
              backgroundColor: Colors.black.withOpacity(0.3),
              foregroundColor: Colors.white,
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CreateDiary()),
              );
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(20),
              backgroundColor: Colors.blue[300],
              foregroundColor: Colors.white,
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ImageGallery()));
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(10),
              backgroundColor: Colors.black.withOpacity(0.3),
              foregroundColor: Colors.white,
            ),
            child: const Icon(
              Icons.photo_library_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
