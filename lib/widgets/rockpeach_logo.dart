import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RockpeachLogo extends StatelessWidget {
  final double height;
  final double? width;
  final Alignment alignment;
  final BoxFit fit;
  final bool clickable;
  final bool square;

  const RockpeachLogo({
    super.key,
    this.height = 30,
    this.width,
    this.alignment = Alignment.centerLeft,
    this.fit = BoxFit.fill,
    this.clickable = true,
    this.square = false,
  });

  @override
  Widget build(BuildContext context) {
    final Widget logo = square
        ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'images/rockpeach_logo_square.png',
              height: height,
              width: width,
              alignment: alignment,
              fit: fit,
            ),
          )
        : SvgPicture.string(
            _svgString,
            height: height,
            width: width,
            alignment: alignment,
            fit: fit,
          );
    if (clickable) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => launchUrlString('https://rockpeach.io/'),
          child: logo,
        ),
      );
    } else {
      return logo;
    }
  }

  static const String _svgString = '''<?xml version="1.0" encoding="utf-8"?>
      <svg id="Camada_1" xmlns="http://www.w3.org/2000/svg" version="1.1" viewBox="170 430 1400 260">
        <defs>
              <linearGradient id="grad1" x1="181.1" y1="560.38" x2="1565.81" y2="560.38" gradientUnits="userSpaceOnUse">
                <stop offset="0" stop-color="#0093ed"/>
                <stop offset=".03" stop-color="#108ee4"/>
                <stop offset=".11" stop-color="#3d83cc"/>
                <stop offset=".2" stop-color="#6479b7"/>
                <stop offset=".3" stop-color="#8671a6"/>
                <stop offset=".4" stop-color="#a16a97"/>
                <stop offset=".51" stop-color="#b5658c"/>
                <stop offset=".63" stop-color="#c46184"/>
                <stop offset=".77" stop-color="#cd5f80"/>
                <stop offset="1" stop-color="#d05f7f"/>
              </linearGradient>
        </defs>
        <path class="st0" fill="url(#grad1)" d="M232.36,631.28l-51.26-.04,42.82-177.82,77.49.07c46.54.04,65.11,22.37,55.94,60.45-5.04,20.95-19.83,41.15-40.22,50.01l16.89,67.44-57.3-.05-13.2-59.67h-16.8s-14.36,59.63-14.36,59.63ZM255.03,537.13l21.16.02c14.39.01,25.38-8.98,28.61-22.41,3.18-13.19-3.85-22.68-17.63-22.69l-21.28-.02-10.86,45.1Z"/>
        <path class="st0" fill="url(#grad1)" d="M357.99,562c10.95-45.47,45.29-72.56,88.69-72.52,43.64.04,64.74,26.93,53.73,72.65-11.28,46.83-44.5,72.81-88.75,72.77-44.13-.04-64.92-26.19-53.67-72.89ZM450.09,562.2c5.52-22.92.68-36.48-12.13-36.5-12.81-.01-24.18,13.54-29.7,36.46-5.67,23.54-.93,36.48,12.13,36.5,12.94.01,24.03-12.92,29.7-36.46Z"/>
        <path class="st0" fill="url(#grad1)" d="M606.71,550.01c2.29-14.05-3.37-22.68-14.49-22.69-13.66-.01-24.12,12.3-29.55,34.86-5.52,22.92-1.08,35.13,12.7,35.14,11.49,0,20.91-7.99,25.2-21.79l45.09.04c-9.57,37.22-39.96,59.5-79.98,59.46-43.88-.04-64.17-27.3-53.19-72.89,10.86-45.1,44.44-72.56,87.96-72.52,39.29.04,59.55,23.35,51.35,60.44l-45.09-.04Z"/>
        <path class="st0" fill="url(#grad1)" d="M765.62,493.21l54.64.05-59.94,59.11,29.73,79.4-56.94-.05-16.93-49.2-9.09,9.11-9.65,40.05-49.57-.04,45.05-187.07,49.57.04-23.83,98.96h.97l45.99-50.37Z"/>
        <path class="st0" fill="url(#grad1)" d="M956.64,562.65c-10.98,45.6-36.13,71.21-69.98,71.18-19.95-.02-32.47-9.77-34.87-25.92h-.97s-16.44,68.27-16.44,68.27l-49.57-.04,44.04-182.88,49.57.04-5.99,24.89h.97c10.59-16.88,27.5-26.84,46.97-26.83,34.33.03,47.29,25.56,36.28,71.27ZM905.87,562.6c4.72-19.59-.96-32.17-14.38-32.18-13.54-.01-25.15,12.55-30.02,32.27-4.66,19.84.87,32.05,14.53,32.06,13.54.01,25.12-12.43,29.87-32.14Z"/>
        <path class="st0" fill="url(#grad1)" d="M1100.41,587.3c-11.38,29.7-41.34,48.16-78.34,48.12-44.37-.04-64.35-27.05-53.51-72.03,10.89-45.23,44.41-73.42,86.96-73.38,41.83.04,62.32,27.42,52.11,69.81l-3.29,13.68-90.31-.08-.77,3.2c-3.38,14.05,4.01,24.04,17.91,24.05,10.4,0,19.96-5.04,25-13.41l44.25.04ZM1021.37,545.94l43.28.04c2.24-12.82-4.36-21.08-16.57-21.09-11.73,0-22.78,8.73-26.71,21.05Z"/>
        <path class="st0" fill="url(#grad1)" d="M1110.58,591.75c6.38-26.49,29.8-40.89,66.6-43.08l30.43-1.82,1.69-7.02c2.28-9.49-3.48-14.67-13.27-14.68-10.52,0-18.71,5.9-21.28,13.05l-44.25-.04c8.27-29.33,37.32-48.04,76.62-48,37.48.03,57.9,19.16,51.14,47.25l-22.82,94.77-48.36-.04,4.51-18.73h-.97c-10.4,13.55-28.56,20.68-44.4,20.67-24.9-.02-41.66-17.29-35.64-42.31ZM1198.89,583.07l2.2-9.12-22.27,1.58c-10.09.73-16.78,5.41-18.47,12.43-1.84,7.64,3.23,12.21,12.42,12.21,11.49.01,23.61-6.63,26.13-17.11Z"/>
        <path class="st0" fill="url(#grad1)" d="M1362.07,550.68c2.29-14.05-3.37-22.68-14.49-22.69-13.66-.01-24.12,12.3-29.55,34.86-5.52,22.92-1.08,35.13,12.7,35.14,11.49,0,20.91-7.99,25.2-21.79l45.09.04c-9.57,37.22-39.96,59.5-79.98,59.46-43.88-.04-64.17-27.3-53.18-72.89,10.86-45.1,44.44-72.56,87.96-72.52,39.29.03,59.55,23.35,51.35,60.44l-45.09-.04Z"/>
        <path class="st0" fill="url(#grad1)" d="M1448.29,445.25l48.36.04-18.22,75.67h.97c11.55-19.34,28.94-29.8,49.62-29.78,30.46.03,42.37,19.39,34.39,52.54l-21.37,88.73-49.57-.04,18.67-77.51c3.41-14.17-1.25-22.93-14.19-22.94-12.94-.01-22.26,9.59-25.47,22.9l-18.67,77.51-49.57-.04,45.05-187.07Z"/>
      </svg>''';
}
