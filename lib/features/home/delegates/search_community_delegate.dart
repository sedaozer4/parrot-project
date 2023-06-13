import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchCommunityDelegate(this.ref);

  //arama çubuğunun sağ tarafında görünen butonu oluşturur.
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  //arama çubuğunun sol tarafındaki geri butonunu oluşturur.
  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  //arama sonuçlarının görüntülendiği widget'ı oluşturur.
  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  // arama önerilerinin görüntülendiği widget'ı oluşturur.
  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchCommunityProvider(query)).when(
          data: (communites) => ListView.builder(
            itemCount: communites.length,
            itemBuilder: (BuildContext context, int index) {
              final community = communites[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(community.avatar),
                ),
                title: Text('r/${community.name}'),
                onTap: () => navigateToCommunity(context, community.name),
              );
            },
          ),
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }

  //topluluğa tıklanıldığında ilgili topluluk sayfasına yönlendirmek için kullanılır.
  void navigateToCommunity(BuildContext context, String communityName) {
    Routemaster.of(context).push('/r/$communityName');
  }
}
