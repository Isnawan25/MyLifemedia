import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylm/screen/message/message_status_screen.dart';


class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  //dummy pesan
  final List<Map<String, String>> messages = [
    {
      'title': 'Perubahan layanan telah berhasil',
      'subtitle': 'Perubahan layanan IndiHome Lite 50 Mbps dengan nomor 100014...',
      'time': '10:55',
    },
    {
      'title': 'Perubahan layanan dalam proses',
      'subtitle': 'Perubahan layanan IndiHome Lite 30 Mbps dengan nomor 100014...',
      'time': 'Kemarin',
    },
    {
      'title': 'Pembayaran tagihan berhasil',
      'subtitle': 'Pembayaran tagihan bulan Oktober 2025 telah berhasil dilakukan.',
      'time': '01/10/25',
    },
    {
      'title': 'Pembayaran tagihan berhasil',
      'subtitle': 'Pembayaran tagihan bulan September 2025 telah berhasil dilakukan.',
      'time': '01/09/25',
    },
  ];

  // status pesan sudah dibaca/belum
  late List<bool> isRead;

  @override
  void initState() {
    super.initState();
    isRead = List.filled(messages.length, false); // awalnya semua belum dibaca
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/svgs/arrow_back.svg",
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Pesan",
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 24.w),
            child: Icon(
              Icons.more_vert,
              color: Colors.black54,
              size: 22.sp,
            ),
          )
        ],
      ),

      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
        itemCount: messages.length,
        separatorBuilder: (context, index) =>
            Divider(height: 1.h, color: Colors.grey[300]),
        itemBuilder: (context, index) {
          final msg = messages[index];
          final read = isRead[index];

          return InkWell(
            onTap: () {
              setState(() {
                isRead[index] = true;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessageStatusScreen(
                    judulBantuan: messages[index]['title']!,
                    deskripsi: messages[index]['subtitle']!,
                    waktu: messages[index]['time']!,
                  ),
                ),
              );
            },


            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titik merah di kiri (hanya muncul jika belum dibaca)
                  if (!read)
                    Container(
                      width: 10.w,
                      height: 10.w,
                      margin: EdgeInsets.only(top: 6.h, right: 12.w),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    )
                  else
                    SizedBox(width: 22.w),

                  // Isi pesan
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg['title']!,
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight:
                            read ? FontWeight.w400 : FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          msg['subtitle']!,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Waktu di kanan
                  Text(
                    msg['time']!,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}