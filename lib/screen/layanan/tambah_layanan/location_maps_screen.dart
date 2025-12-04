import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screenshot/screenshot.dart';

class LocationMapsScreen extends StatefulWidget {
  const LocationMapsScreen({super.key});

  @override
  State<LocationMapsScreen> createState() => _LocationMapsScreenState();
}

class _LocationMapsScreenState extends State<LocationMapsScreen> {
  late final MapController controller;
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    controller = MapController.withUserPosition();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _pilihLokasi() async {
    // Ambil koordinat tengah peta
    final GeoPoint point = await controller.centerMap;

    // Ambil screenshot otomatis dari tampilan peta
    final Uint8List? image = await screenshotController.capture();

    if (!mounted) return;

    // Kembalikan data ke halaman sebelumnya (tanpa simpan ke storage)
    Navigator.pop(context, {'point': point, 'image': image});
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Pilih Lokasi Anda",
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Screenshot(
            controller: screenshotController,
            child: OSMFlutter(
              controller: controller,
              mapIsLoading: const Center(child: CircularProgressIndicator()),
              osmOption: OSMOption(
                enableRotationByGesture: false,
                zoomOption: const ZoomOption(
                  initZoom: 16,
                  minZoomLevel: 3,
                  maxZoomLevel: 19,
                  stepZoom: 1.0,
                ),
                userLocationMarker: UserLocationMaker(
                  personMarker: MarkerIcon(
                    iconWidget: Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,

                        color: Colors.transparent,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 50.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: darkorange.withValues(alpha: 0.25),
                            ),
                          ),
                          Container(
                            width: 20.w,
                            height: 20.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: darkorange,
                              border: Border.all(
                                color: Colors.white,
                                width: 3.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  directionArrowMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.navigation,
                      color: darkorange,
                      size: 48,
                    ),
                  ),
                ),
                roadConfiguration: const RoadOption(
                  roadColor: darkorange,
                ),
              ),
            ),
          ),

          // Penanda di tengah peta
          Center(
            child: Icon(
              Icons.location_on,
              color: darkorange.withValues(alpha: 0.9),
              size: 48,
            ),
          ),

          // Tombol Pilih Lokasi
          Positioned(
            bottom: 28,
            left: 24,
            right: 24,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [darkorange, orange],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check, color: Colors.white),
                label: Text(
                  "Pilih Lokasi Ini",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _pilihLokasi,
              ),
            ),
          ),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90, right: 8),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [darkorange, orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(Icons.my_location, color: Colors.white),
            onPressed: () async {
              await controller.currentLocation();
            },
          ),
        ),
      ),
    );
  }
}
