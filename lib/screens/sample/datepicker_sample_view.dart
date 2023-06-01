import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatepickerSampleView extends StatefulWidget {
  const DatepickerSampleView({Key? key}) : super(key: key);

  @override
  State<DatepickerSampleView> createState() => _DatepickerSampleViewState();
}

class _DatepickerSampleViewState extends State<DatepickerSampleView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: SfDateRangePicker(
          view: DateRangePickerView.month,
          selectionMode: DateRangePickerSelectionMode.multiple,
          monthViewSettings: DateRangePickerMonthViewSettings(
              blackoutDates: [DateTime(2023, 05, 18), DateTime(2023, 05, 22)]),
          onSelectionChanged: (DateRangePickerSelectionChangedArgs
              dateRangePickerSelectionChangedArgs) {
            print(dateRangePickerSelectionChangedArgs.value);
          },
          navigationDirection: DateRangePickerNavigationDirection.vertical,
          viewSpacing: 10,
        ),
      ),
    );
  }
}
