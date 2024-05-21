import 'package:artistry/models/workshop_model.dart';
import 'package:artistry/screens/user/Artist_user/onlineClassesPage.dart';
import 'package:artistry/services/workshop_service.dart';
import 'package:flutter/material.dart';


class WorkshopListScreen extends StatefulWidget {
  final String? artistId;

  WorkshopListScreen({Key? key, this.artistId}) : super(key: key);

  @override
  _WorkshopListScreenState createState() => _WorkshopListScreenState();
}

class _WorkshopListScreenState extends State<WorkshopListScreen> {
  final WorkshopService _workshopService = WorkshopService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workshops'),
      ),
      body: StreamBuilder<List<Workshop>>(
        stream: _workshopService.getWorkshopsbyId(widget.artistId.toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }



          else {
            final workshops = snapshot.data!;

            if(workshops.isEmpty){

              return Center(
                child: Text(
                  "No Data"
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: workshops.length,
                itemBuilder: (context, index) {
                  final workshop = workshops[index];
                  return Card(
                    child: ListTile(
                      trailing: IconButton(onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkshopForm(
                              workshop: workshop,
                            ),
                          ),
                        ).then((_) {
                          setState(() {});
                        });
                      }  ,icon: Icon(Icons.edit),),
                      title: Text(workshop.title),
                      subtitle: Text(workshop.description),
                      leading: CircleAvatar(

                        child: Center(child: Text("${index+1}"),),
                      ),
                      onTap: () {

                      },
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkshopForm(artistId: widget.artistId),
            ),
          ).then((_) {
            setState(() {});
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
