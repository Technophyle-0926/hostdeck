// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aggregated_build_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAggregatedBuildModelCollection on Isar {
  IsarCollection<AggregatedBuildModel> get aggregatedBuildModels =>
      this.collection();
}

const AggregatedBuildModelSchema = CollectionSchema(
  name: r'AggregatedBuildModel',
  id: -7672414250143312042,
  properties: {
    r'appIconUrl': PropertySchema(
      id: 0,
      name: r'appIconUrl',
      type: IsarType.string,
    ),
    r'downloadUrl': PropertySchema(
      id: 1,
      name: r'downloadUrl',
      type: IsarType.string,
    ),
    r'environment': PropertySchema(
      id: 2,
      name: r'environment',
      type: IsarType.string,
    ),
    r'hostAccountId': PropertySchema(
      id: 3,
      name: r'hostAccountId',
      type: IsarType.long,
    ),
    r'platform': PropertySchema(
      id: 4,
      name: r'platform',
      type: IsarType.string,
    ),
    r'projectId': PropertySchema(
      id: 5,
      name: r'projectId',
      type: IsarType.string,
    ),
    r'projectName': PropertySchema(
      id: 6,
      name: r'projectName',
      type: IsarType.string,
    ),
    r'sizeMb': PropertySchema(id: 7, name: r'sizeMb', type: IsarType.double),
    r'uploadDate': PropertySchema(
      id: 8,
      name: r'uploadDate',
      type: IsarType.dateTime,
    ),
    r'version': PropertySchema(id: 9, name: r'version', type: IsarType.string),
  },

  estimateSize: _aggregatedBuildModelEstimateSize,
  serialize: _aggregatedBuildModelSerialize,
  deserialize: _aggregatedBuildModelDeserialize,
  deserializeProp: _aggregatedBuildModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'hostAccountId': IndexSchema(
      id: 993912260112710838,
      name: r'hostAccountId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'hostAccountId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _aggregatedBuildModelGetId,
  getLinks: _aggregatedBuildModelGetLinks,
  attach: _aggregatedBuildModelAttach,
  version: '3.3.2',
);

int _aggregatedBuildModelEstimateSize(
  AggregatedBuildModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.appIconUrl.length * 3;
  bytesCount += 3 + object.downloadUrl.length * 3;
  bytesCount += 3 + object.environment.length * 3;
  bytesCount += 3 + object.platform.length * 3;
  bytesCount += 3 + object.projectId.length * 3;
  bytesCount += 3 + object.projectName.length * 3;
  bytesCount += 3 + object.version.length * 3;
  return bytesCount;
}

void _aggregatedBuildModelSerialize(
  AggregatedBuildModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.appIconUrl);
  writer.writeString(offsets[1], object.downloadUrl);
  writer.writeString(offsets[2], object.environment);
  writer.writeLong(offsets[3], object.hostAccountId);
  writer.writeString(offsets[4], object.platform);
  writer.writeString(offsets[5], object.projectId);
  writer.writeString(offsets[6], object.projectName);
  writer.writeDouble(offsets[7], object.sizeMb);
  writer.writeDateTime(offsets[8], object.uploadDate);
  writer.writeString(offsets[9], object.version);
}

AggregatedBuildModel _aggregatedBuildModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AggregatedBuildModel();
  object.appIconUrl = reader.readString(offsets[0]);
  object.downloadUrl = reader.readString(offsets[1]);
  object.environment = reader.readString(offsets[2]);
  object.hostAccountId = reader.readLong(offsets[3]);
  object.id = id;
  object.platform = reader.readString(offsets[4]);
  object.projectId = reader.readString(offsets[5]);
  object.projectName = reader.readString(offsets[6]);
  object.sizeMb = reader.readDouble(offsets[7]);
  object.uploadDate = reader.readDateTime(offsets[8]);
  object.version = reader.readString(offsets[9]);
  return object;
}

P _aggregatedBuildModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _aggregatedBuildModelGetId(AggregatedBuildModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _aggregatedBuildModelGetLinks(
  AggregatedBuildModel object,
) {
  return [];
}

void _aggregatedBuildModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  AggregatedBuildModel object,
) {
  object.id = id;
}

extension AggregatedBuildModelQueryWhereSort
    on QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QWhere> {
  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterWhere>
  anyHostAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'hostAccountId'),
      );
    });
  }
}

extension AggregatedBuildModelQueryWhere
    on QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QWhereClause> {
  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterWhereClause>
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

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterWhereClause>
  idBetween(
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

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterWhereClause>
  hostAccountIdEqualTo(int hostAccountId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'hostAccountId',
          value: [hostAccountId],
        ),
      );
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterWhereClause>
  hostAccountIdNotEqualTo(int hostAccountId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'hostAccountId',
                lower: [],
                upper: [hostAccountId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'hostAccountId',
                lower: [hostAccountId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'hostAccountId',
                lower: [hostAccountId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'hostAccountId',
                lower: [],
                upper: [hostAccountId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterWhereClause>
  hostAccountIdGreaterThan(int hostAccountId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'hostAccountId',
          lower: [hostAccountId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterWhereClause>
  hostAccountIdLessThan(int hostAccountId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'hostAccountId',
          lower: [],
          upper: [hostAccountId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterWhereClause>
  hostAccountIdBetween(
    int lowerHostAccountId,
    int upperHostAccountId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'hostAccountId',
          lower: [lowerHostAccountId],
          includeLower: includeLower,
          upper: [upperHostAccountId],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension AggregatedBuildModelQueryFilter
    on
        QueryBuilder<
          AggregatedBuildModel,
          AggregatedBuildModel,
          QFilterCondition
        > {
  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  appIconUrlEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'appIconUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  appIconUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'appIconUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  appIconUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'appIconUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  appIconUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'appIconUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  appIconUrlStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'appIconUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  appIconUrlEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'appIconUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  appIconUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'appIconUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  appIconUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'appIconUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  appIconUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'appIconUrl', value: ''),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  appIconUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'appIconUrl', value: ''),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  downloadUrlEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'downloadUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  downloadUrlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'downloadUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  downloadUrlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'downloadUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  downloadUrlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'downloadUrl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  downloadUrlStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'downloadUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  downloadUrlEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'downloadUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  downloadUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'downloadUrl',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  downloadUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'downloadUrl',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  downloadUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'downloadUrl', value: ''),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  downloadUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'downloadUrl', value: ''),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  environmentEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'environment',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  environmentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'environment',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  environmentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'environment',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  environmentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'environment',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  environmentStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'environment',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  environmentEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'environment',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  environmentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'environment',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  environmentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'environment',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  environmentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'environment', value: ''),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  environmentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'environment', value: ''),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  hostAccountIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hostAccountId', value: value),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  hostAccountIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'hostAccountId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  hostAccountIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'hostAccountId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  hostAccountIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'hostAccountId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  platformEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'platform',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  platformGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'platform',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  platformLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'platform',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  platformBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'platform',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  platformStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'platform',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  platformEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'platform',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  platformContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'platform',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  platformMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'platform',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  platformIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'platform', value: ''),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  platformIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'platform', value: ''),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  projectIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'projectId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  projectIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'projectId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  projectIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'projectId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  projectIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'projectId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  projectIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'projectId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  projectIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'projectId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  projectIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'projectId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  projectIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'projectId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  projectIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'projectId', value: ''),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  projectIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'projectId', value: ''),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  projectNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'projectName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  projectNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'projectName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  projectNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'projectName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  projectNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'projectName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  projectNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'projectName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  projectNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'projectName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  projectNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'projectName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  projectNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'projectName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  projectNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'projectName', value: ''),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  projectNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'projectName', value: ''),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  sizeMbEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'sizeMb',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  sizeMbGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sizeMb',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  sizeMbLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sizeMb',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  sizeMbBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sizeMb',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  uploadDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'uploadDate', value: value),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  uploadDateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'uploadDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  uploadDateLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'uploadDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  uploadDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'uploadDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  versionEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'version',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  versionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'version',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  versionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'version',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  versionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'version',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  versionStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'version',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  versionEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'version',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  versionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'version',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  versionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'version',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  versionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'version', value: ''),
      );
    });
  }

  QueryBuilder<
    AggregatedBuildModel,
    AggregatedBuildModel,
    QAfterFilterCondition
  >
  versionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'version', value: ''),
      );
    });
  }
}

extension AggregatedBuildModelQueryObject
    on
        QueryBuilder<
          AggregatedBuildModel,
          AggregatedBuildModel,
          QFilterCondition
        > {}

extension AggregatedBuildModelQueryLinks
    on
        QueryBuilder<
          AggregatedBuildModel,
          AggregatedBuildModel,
          QFilterCondition
        > {}

extension AggregatedBuildModelQuerySortBy
    on QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QSortBy> {
  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  sortByAppIconUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appIconUrl', Sort.asc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  sortByAppIconUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appIconUrl', Sort.desc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  sortByDownloadUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadUrl', Sort.asc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  sortByDownloadUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadUrl', Sort.desc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  sortByEnvironment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'environment', Sort.asc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  sortByEnvironmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'environment', Sort.desc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  sortByHostAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hostAccountId', Sort.asc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  sortByHostAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hostAccountId', Sort.desc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  sortByPlatform() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platform', Sort.asc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  sortByPlatformDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platform', Sort.desc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  sortByProjectId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectId', Sort.asc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  sortByProjectIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectId', Sort.desc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  sortByProjectName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectName', Sort.asc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  sortByProjectNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectName', Sort.desc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  sortBySizeMb() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeMb', Sort.asc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  sortBySizeMbDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeMb', Sort.desc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  sortByUploadDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadDate', Sort.asc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  sortByUploadDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadDate', Sort.desc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  sortByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  sortByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension AggregatedBuildModelQuerySortThenBy
    on QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QSortThenBy> {
  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  thenByAppIconUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appIconUrl', Sort.asc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  thenByAppIconUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appIconUrl', Sort.desc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  thenByDownloadUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadUrl', Sort.asc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  thenByDownloadUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadUrl', Sort.desc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  thenByEnvironment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'environment', Sort.asc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  thenByEnvironmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'environment', Sort.desc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  thenByHostAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hostAccountId', Sort.asc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  thenByHostAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hostAccountId', Sort.desc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  thenByPlatform() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platform', Sort.asc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  thenByPlatformDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'platform', Sort.desc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  thenByProjectId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectId', Sort.asc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  thenByProjectIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectId', Sort.desc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  thenByProjectName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectName', Sort.asc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  thenByProjectNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectName', Sort.desc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  thenBySizeMb() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeMb', Sort.asc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  thenBySizeMbDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sizeMb', Sort.desc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  thenByUploadDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadDate', Sort.asc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  thenByUploadDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uploadDate', Sort.desc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  thenByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QAfterSortBy>
  thenByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }
}

extension AggregatedBuildModelQueryWhereDistinct
    on QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QDistinct> {
  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QDistinct>
  distinctByAppIconUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'appIconUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QDistinct>
  distinctByDownloadUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'downloadUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QDistinct>
  distinctByEnvironment({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'environment', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QDistinct>
  distinctByHostAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hostAccountId');
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QDistinct>
  distinctByPlatform({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'platform', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QDistinct>
  distinctByProjectId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'projectId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QDistinct>
  distinctByProjectName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'projectName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QDistinct>
  distinctBySizeMb() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sizeMb');
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QDistinct>
  distinctByUploadDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uploadDate');
    });
  }

  QueryBuilder<AggregatedBuildModel, AggregatedBuildModel, QDistinct>
  distinctByVersion({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'version', caseSensitive: caseSensitive);
    });
  }
}

extension AggregatedBuildModelQueryProperty
    on
        QueryBuilder<
          AggregatedBuildModel,
          AggregatedBuildModel,
          QQueryProperty
        > {
  QueryBuilder<AggregatedBuildModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AggregatedBuildModel, String, QQueryOperations>
  appIconUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appIconUrl');
    });
  }

  QueryBuilder<AggregatedBuildModel, String, QQueryOperations>
  downloadUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloadUrl');
    });
  }

  QueryBuilder<AggregatedBuildModel, String, QQueryOperations>
  environmentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'environment');
    });
  }

  QueryBuilder<AggregatedBuildModel, int, QQueryOperations>
  hostAccountIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hostAccountId');
    });
  }

  QueryBuilder<AggregatedBuildModel, String, QQueryOperations>
  platformProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'platform');
    });
  }

  QueryBuilder<AggregatedBuildModel, String, QQueryOperations>
  projectIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'projectId');
    });
  }

  QueryBuilder<AggregatedBuildModel, String, QQueryOperations>
  projectNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'projectName');
    });
  }

  QueryBuilder<AggregatedBuildModel, double, QQueryOperations>
  sizeMbProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sizeMb');
    });
  }

  QueryBuilder<AggregatedBuildModel, DateTime, QQueryOperations>
  uploadDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uploadDate');
    });
  }

  QueryBuilder<AggregatedBuildModel, String, QQueryOperations>
  versionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'version');
    });
  }
}
