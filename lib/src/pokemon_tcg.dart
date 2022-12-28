import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pokemon_tcg/src/models/card.dart';
import 'package:pokemon_tcg/src/models/elemental_type.dart';
import 'package:pokemon_tcg/src/models/rarity.dart';
import 'package:pokemon_tcg/src/models/set.dart';
import 'package:pokemon_tcg/src/models/subtype.dart';
import 'package:pokemon_tcg/src/models/supertype.dart';
import 'package:pokemon_tcg/src/type_aliases.dart';

class PokemonTcgApi {
  PokemonTcgApi({
    required this.apiKey,
    required this.client,
  });

  final String apiKey;
  final http.Client client;

  static const _scheme = 'https';
  static const _host = 'api.pokemontcg.io';
  static const _pathPrefix = '/v2';

  static Uri _buildUrl(String path, {Map<String, String?>? queryParameters}) {
    return new Uri(
        scheme: _scheme,
        host: _host,
        path: _pathPrefix + '/' + path,
        queryParameters: queryParameters);
  }

  /// Gets a paginated list of all pokemon cards.
  Future<List<PokemonCard>> getCards({
    int page = 1,
    int pageSize = 250,
    List<String>? orderBy,
    List<String>? select,
    String? q
  }) async {
    http.Response response;

    response = await client.get(
      _buildUrl('cards', queryParameters: {
        'page': page.toString(),
        'pageSize': pageSize.toString(),
        'orderBy': orderBy?.join(','),
        'select': select?.join(','),
        'q': q,
      }),
      headers: {
        'x-api-key': apiKey,
      },
    );

    JsonMap json = jsonDecode(response.body);
    final cards = <PokemonCard>[];
    List<dynamic> cardsJson = json['data'];
    cardsJson.forEach((element) {
      cards.add(PokemonCard.fromJson(element));
    });
    return cards;
  }

  /// Gets a paginated list of all pokemon cards for a particular set.
  Future<List<PokemonCard>> getCardsForSet(
    String setId, {
    int page = 1,
    int pageSize = 250,
  }) async {
    http.Response response;

    response = await client.get(
      _buildUrl('cards', queryParameters: {
        'page': page.toString(),
        'pageSize': pageSize.toString(),
        'q': 'set.id:$setId',
      }),
      headers: {
        'x-api-key': apiKey,
      },
    );

    JsonMap json = jsonDecode(response.body);
    final cards = <PokemonCard>[];
    List<dynamic> cardsJson = json['data'];
    cardsJson.forEach((element) {
      cards.add(PokemonCard.fromJson(element));
    });
    return cards;
  }

  /// Gets a single pokemon card based on the card ID (e.g. 'xy7-54')
  Future<PokemonCard> getCard(String cardId) async {
    final response = await client.get(
      _buildUrl('cards/$cardId'),
      headers: {
        'x-api-key': apiKey,
      },
    );

    final json = jsonDecode(response.body);
    return PokemonCard.fromJson(json['data']);
  }

  /// Get All Sets
  Future<CardSets> getSets({
    page = 1,
    pageSize = 250,
    List<String>? orderBy,
    List<String>? select,
    String? q,
  }) async {
    final response = await client.get(
      _buildUrl('sets', queryParameters: {
        'page': page.toString(),
        'pageSize': pageSize.toString(),
        'orderBy': orderBy?.join(','),
        'select': select?.join(','),
        'q': q,
      }),
      headers: {
        'x-api-key': apiKey,
      },
    );

    JsonMap json = jsonDecode(response.body);
    final cardSets = <CardSet>[];
    List<dynamic> sets = json['data'];
    sets.forEach((element) {
      cardSets.add(CardSet.fromJson(element));
    });
    return cardSets;
  }

  /// Returns a specific set by the set code
  Future<CardSet> getSet(String setId) async {
    final response = await client.get(
      _buildUrl('sets/$setId'),
      headers: {
        'x-api-key': apiKey,
      },
    );

    final json = jsonDecode(response.body);
    return CardSet.fromJson(json['data']);
  }

  /// Get All Types
  Future<List<ElementalType>> getTypes() async {
    final response = await client.get(
      _buildUrl('types'),
      headers: {
        'x-api-key': apiKey,
      },
    );

    final types = <ElementalType>[];

    final json = jsonDecode(response.body);
    json['data'].forEach((type) {
      types.add(ElementalType(type: type));
    });

    return types;
  }

  /// Get All Subtypes
  Future<List<Subtype>> getSubtypes() async {
    final response = await client.get(
      _buildUrl('subtypes'),
      headers: {
        'x-api-key': apiKey,
      },
    );

    final types = <Subtype>[];

    final json = jsonDecode(response.body);
    json['data'].forEach((type) {
      types.add(Subtype(type: type));
    });

    return types;
  }

  /// Get All Supertypes
  Future<List<Supertype>> getSupertypes() async {
    final response = await client.get(
      _buildUrl('supertypes'),
      headers: {
        'x-api-key': apiKey,
      },
    );

    final types = <Supertype>[];

    final json = jsonDecode(response.body);
    json['data'].forEach((type) {
      types.add(Supertype(type: type));
    });

    return types;
  }

  /// Get All Rarities
  Future<List<Rarity>> getRarities() async {
    final response = await client.get(
      _buildUrl('rarities'),
      headers: {
        'x-api-key': apiKey,
      },
    );

    final types = <Rarity>[];

    final json = jsonDecode(response.body);
    json['data'].forEach((type) {
      types.add(Rarity(type: type));
    });

    return types;
  }
}
