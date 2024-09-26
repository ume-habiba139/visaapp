import 'package:flutter/material.dart';
import 'package:visaapp/Database/database_helper.dart';

class VisaInfoListScreen extends StatefulWidget {
  @override
  _VisaInfoListScreenState createState() => _VisaInfoListScreenState();
}

class _VisaInfoListScreenState extends State<VisaInfoListScreen> {
  late Future<List<ApplyVisa>> _visaInfoList;

  @override
  void initState() {
    super.initState();
    _visaInfoList = DatabaseHelper.instance.getapplyVisaInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visa Information'),
      ),
      body: FutureBuilder<List<ApplyVisa>>(
        future: _visaInfoList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching visa information: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final visaInfoList = snapshot.data!;

            if (visaInfoList.isEmpty) {
              return Center(child: Text('No visa details available.'));
            }

            return ListView.builder(
              itemCount: visaInfoList.length,
              itemBuilder: (context, index) {
                final visa = visaInfoList[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${visa.fullName} has applied for ${visa.visaType}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
