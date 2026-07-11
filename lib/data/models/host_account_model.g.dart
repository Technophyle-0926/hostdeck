// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'host_account_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHostAccountModelCollection on Isar {
  IsarCollection<HostAccountModel> get hostAccountModels => this.collection();
}

const HostAccountModelSchema = CollectionSchema(
  name: r'HostAccountModel',
  id: -4051272760874507,
  properties: {
    r'accountName': PropertySchema(
      id: 0,
      name: r'accountName',
      type: IsarType.string,
    ),
    r'appsCount': PropertySchema(
      id: 1,
      name: r'appsCount',
      type: IsarType.long,
    ),
    r'email': PropertySchema(id: 2, name: r'email', type: IsarType.string),
    r'maxAppsLimit': PropertySchema(
      id: 3,
      name: r'maxAppsLimit',
      type: IsarType.long,
    ),
  },

  estimateSize: _hostAccountModelEstimateSize,
  serialize: _hostAccountModelSerialize,
  deserialize: _hostAccountModelDeserialize,
  deserializeProp: _hostAccountModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _hostAccountModelGetId,
  getLinks: _hostAccountModelGetLinks,
  attach: _hostAccountModelAttach,
  version: '3.3.2',
);

int _hostAccountModelEstimateSize(
  HostAccountModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accountName.length * 3;
  bytesCount += 3 + object.email.length * 3;
  return bytesCount;
}

void _hostAccountModelSerialize(
  HostAccountModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accountName);
  writer.writeLong(offsets[1], object.appsCount);
  writer.writeString(offsets[2], object.email);
  writer.writeLong(offsets[3], object.maxAppsLimit);
}

HostAccountModel _hostAccountModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HostAccountModel();
  object.accountName = reader.readString(offsets[0]);
  object.appsCount = reader.readLong(offsets[1]);
  object.email = reader.readString(offsets[2]);
  object.id = id;
  object.maxAppsLimit = reader.readLong(offsets[3]);
  return object;
}

P _hostAccountModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _hostAccountModelGetId(HostAccountModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _hostAccountModelGetLinks(HostAccountModel object) {
  return [];
}

void _hostAccountModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  HostAccountModel object,
) {
  object.id = id;
}

extension HostAccountModelQueryWhereSort
    on QueryBuilder<HostAccountModel, HostAccountModel, QWhere> {
  QueryBuilder<HostAccountModel, HostAccountModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension HostAccountModelQueryWhere
    on QueryBuilder<HostAccountModel, HostAccountModel, QWhereClause> {
  QueryBuilder<HostAccountModel, HostAccountModel, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterWhereClause>
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension HostAccountModelQueryFilter
    on QueryBuilder<HostAccountModel, HostAccountModel, QFilterCondition> {
  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  accountNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'accountName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  accountNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'accountName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  accountNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'accountName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  accountNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'accountName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  accountNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'accountName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  accountNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'accountName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  accountNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'accountName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  accountNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'accountName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  accountNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'accountName', value: ''),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  accountNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'accountName', value: ''),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  appsCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'appsCount', value: value),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  appsCountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'appsCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  appsCountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'appsCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  appsCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'appsCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  emailEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  emailGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  emailLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  emailBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'email',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  emailStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  emailEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  emailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'email',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  emailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'email',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  emailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'email', value: ''),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  emailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'email', value: ''),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  maxAppsLimitEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'maxAppsLimit', value: value),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  maxAppsLimitGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'maxAppsLimit',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  maxAppsLimitLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'maxAppsLimit',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterFilterCondition>
  maxAppsLimitBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'maxAppsLimit',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension HostAccountModelQueryObject
    on QueryBuilder<HostAccountModel, HostAccountModel, QFilterCondition> {}

extension HostAccountModelQueryLinks
    on QueryBuilder<HostAccountModel, HostAccountModel, QFilterCondition> {}

extension HostAccountModelQuerySortBy
    on QueryBuilder<HostAccountModel, HostAccountModel, QSortBy> {
  QueryBuilder<HostAccountModel, HostAccountModel, QAfterSortBy>
  sortByAccountName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountName', Sort.asc);
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterSortBy>
  sortByAccountNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountName', Sort.desc);
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterSortBy>
  sortByAppsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appsCount', Sort.asc);
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterSortBy>
  sortByAppsCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appsCount', Sort.desc);
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterSortBy> sortByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterSortBy>
  sortByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterSortBy>
  sortByMaxAppsLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxAppsLimit', Sort.asc);
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterSortBy>
  sortByMaxAppsLimitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxAppsLimit', Sort.desc);
    });
  }
}

extension HostAccountModelQuerySortThenBy
    on QueryBuilder<HostAccountModel, HostAccountModel, QSortThenBy> {
  QueryBuilder<HostAccountModel, HostAccountModel, QAfterSortBy>
  thenByAccountName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountName', Sort.asc);
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterSortBy>
  thenByAccountNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountName', Sort.desc);
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterSortBy>
  thenByAppsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appsCount', Sort.asc);
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterSortBy>
  thenByAppsCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appsCount', Sort.desc);
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterSortBy> thenByEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.asc);
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterSortBy>
  thenByEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'email', Sort.desc);
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterSortBy>
  thenByMaxAppsLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxAppsLimit', Sort.asc);
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QAfterSortBy>
  thenByMaxAppsLimitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxAppsLimit', Sort.desc);
    });
  }
}

extension HostAccountModelQueryWhereDistinct
    on QueryBuilder<HostAccountModel, HostAccountModel, QDistinct> {
  QueryBuilder<HostAccountModel, HostAccountModel, QDistinct>
  distinctByAccountName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accountName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QDistinct>
  distinctByAppsCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'appsCount');
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QDistinct> distinctByEmail({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'email', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HostAccountModel, HostAccountModel, QDistinct>
  distinctByMaxAppsLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxAppsLimit');
    });
  }
}

extension HostAccountModelQueryProperty
    on QueryBuilder<HostAccountModel, HostAccountModel, QQueryProperty> {
  QueryBuilder<HostAccountModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HostAccountModel, String, QQueryOperations>
  accountNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountName');
    });
  }

  QueryBuilder<HostAccountModel, int, QQueryOperations> appsCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appsCount');
    });
  }

  QueryBuilder<HostAccountModel, String, QQueryOperations> emailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'email');
    });
  }

  QueryBuilder<HostAccountModel, int, QQueryOperations> maxAppsLimitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxAppsLimit');
    });
  }
}
