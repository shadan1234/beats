import 'package:beats/consts/colors.dart';
import 'package:beats/consts/text_style.dart';
import 'package:beats/controller/player_controller.dart';
import 'package:beats/views/player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var controller=Get.put(PlayerController());
    return Scaffold(
      backgroundColor: bgDarkColor,
      appBar: AppBar(
        backgroundColor: bgDarkColor,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: whiteColor,
              ))
        ],
        leading: Icon(
          Icons.sort_rounded,
          color: whiteColor,
        ),
        title: Text(
          "Beats",
          style: ourStyle(
            family: bold,
            size: 18,
          ),
        ),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: controller.audioQuery.querySongs(
          ignoreCase: true,
          orderType: OrderType.ASC_OR_SMALLER,
          sortType: null,
          uriType: UriType.EXTERNAL,
        ),
        builder: ( context,snapshot)
          {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if(snapshot.data==null) {
              print(snapshot.data);
              return Center(
                child: CircularProgressIndicator(),

              );
            }
             else if(snapshot.data!.isEmpty) {
               return Center(
                 child: Text("NO song found",
                   style: ourStyle(),),
               );
             }
            else {
              print(snapshot.data);
               return Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: ListView.builder(
                     physics: BouncingScrollPhysics(),
                     itemCount: snapshot.data!.length,
                     itemBuilder: (context, index) {
                       return Container(
                           margin: EdgeInsets.only(bottom: 4),

                           child: Obx(()=>
                            ListTile(
                               shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(12)
                               ),
                               tileColor: bgColor,
                               title: Text(
                                 "${snapshot.data![index].displayNameWOExt}",
                                 style: ourStyle(family: bold, size: 15),
                               ),
                               subtitle: Text(
                                 '${snapshot.data![index].artist}',
                                 style: ourStyle(family: regular, size: 12),
                               ),
                               leading: QueryArtworkWidget(id: snapshot.data![index].id,type:
                                 ArtworkType.AUDIO,
                               nullArtworkWidget: Icon(Icons.music_note,color: whiteColor,size: 32,),),
                               trailing: ( controller.playIndex.value==index && controller.isPlaying.value?
                                   Icon(
                                 Icons.play_arrow,
                                 color: whiteColor,
                                 size: 26,
                               ):null),
                               onTap: (){
                                 Get.to(()=>Player(data: snapshot.data!,),
                                 transition: Transition.downToUp,
                                 );

                                 controller.playSong(snapshot.data![index].uri,index);
                               },
                             ),
                           ));
                     }),
               );
             }
          }

      )
    );
  }
}
