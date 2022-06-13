import 'package:flutter/material.dart';
import 'package:sms_advanced/sms_advanced.dart';

class ReadSMS extends StatefulWidget {
  const ReadSMS({Key? key}) : super(key: key);

  @override
  State<ReadSMS> createState() => _ReadSMSState();
}

class _ReadSMSState extends State<ReadSMS> {
  List<SmsMessage> messages = [];
  Future getAllMessages() async {
    SmsQuery query = SmsQuery();
    messages = await query.querySms(kinds: [SmsQueryKind.Inbox, SmsQueryKind.Draft, SmsQueryKind.Sent]);
    debugPrint("Total Messages : " + messages.length.toString());
    // messages.forEach((element) {
    //   print(element.body);
    // });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test read SMS'),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: getAllMessages,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Get Messages',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Icon(Icons.sms, size: 16),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return Wrap(
                  children: [
                    Text(
                      messages[index].toMap.toString(),
                      maxLines: 4,
                    )
                  ],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: 8.0,
              ),
              itemCount: messages.length,
            ),
          ),
        ],
      ),
    );
  }
}
