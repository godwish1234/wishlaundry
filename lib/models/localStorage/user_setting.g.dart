// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_setting.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable

extension GetUserSettingCollection on Isar {
  IsarCollection<UserSetting> get userSettings => getCollection();
}

const UserSettingSchema = CollectionSchema(
  name: 'UserSetting',
  schema:
      '{"name":"UserSetting","idName":"id","properties":[{"name":"isDarkMode","type":"Bool"},{"name":"isNewUser","type":"Bool"},{"name":"languageId","type":"String"},{"name":"name","type":"String"},{"name":"phoneno","type":"String"},{"name":"utcLastUpdated","type":"Long"}],"indexes":[],"links":[]}',
  idName: 'id',
  propertyIds: {
    'isDarkMode': 0,
    'isNewUser': 1,
    'languageId': 2,
    'name': 3,
    'phoneno': 4,
    'utcLastUpdated': 5
  },
  listProperties: {},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {},
  backlinkLinkNames: {},
  getId: _userSettingGetId,
  setId: _userSettingSetId,
  getLinks: _userSettingGetLinks,
  attachLinks: _userSettingAttachLinks,
  serializeNative: _userSettingSerializeNative,
  deserializeNative: _userSettingDeserializeNative,
  deserializePropNative: _userSettingDeserializePropNative,
  serializeWeb: _userSettingSerializeWeb,
  deserializeWeb: _userSettingDeserializeWeb,
  deserializePropWeb: _userSettingDeserializePropWeb,
  version: 3,
);

int? _userSettingGetId(UserSetting object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _userSettingSetId(UserSetting object, int id) {
  object.id = id;
}

List<IsarLinkBase> _userSettingGetLinks(UserSetting object) {
  return [];
}

void _userSettingSerializeNative(
    IsarCollection<UserSetting> collection,
    IsarRawObject rawObj,
    UserSetting object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = object.isDarkMode;
  final _isDarkMode = value0;
  final value1 = object.isNewUser;
  final _isNewUser = value1;
  final value2 = object.languageId;
  IsarUint8List? _languageId;
  if (value2 != null) {
    _languageId = IsarBinaryWriter.utf8Encoder.convert(value2);
  }
  dynamicSize += (_languageId?.length ?? 0) as int;
  final value3 = object.name;
  IsarUint8List? _name;
  if (value3 != null) {
    _name = IsarBinaryWriter.utf8Encoder.convert(value3);
  }
  dynamicSize += (_name?.length ?? 0) as int;
  final value4 = object.phoneno;
  IsarUint8List? _phoneno;
  if (value4 != null) {
    _phoneno = IsarBinaryWriter.utf8Encoder.convert(value4);
  }
  dynamicSize += (_phoneno?.length ?? 0) as int;
  final value5 = object.utcLastUpdated;
  final _utcLastUpdated = value5;
  final size = staticSize + dynamicSize;

  rawObj.buffer = alloc(size);
  rawObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeBool(offsets[0], _isDarkMode);
  writer.writeBool(offsets[1], _isNewUser);
  writer.writeBytes(offsets[2], _languageId);
  writer.writeBytes(offsets[3], _name);
  writer.writeBytes(offsets[4], _phoneno);
  writer.writeDateTime(offsets[5], _utcLastUpdated);
}

UserSetting _userSettingDeserializeNative(
    IsarCollection<UserSetting> collection,
    int id,
    IsarBinaryReader reader,
    List<int> offsets) {
  final object = UserSetting(
    isDarkMode: reader.readBoolOrNull(offsets[0]),
    isNewUser: reader.readBool(offsets[1]),
    languageId: reader.readStringOrNull(offsets[2]),
    name: reader.readStringOrNull(offsets[3]),
    phoneno: reader.readStringOrNull(offsets[4]),
    utcLastUpdated: reader.readDateTime(offsets[5]),
  );
  object.id = id;
  return object;
}

P _userSettingDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readBoolOrNull(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _userSettingSerializeWeb(
    IsarCollection<UserSetting> collection, UserSetting object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(jsObj, 'isDarkMode', object.isDarkMode);
  IsarNative.jsObjectSet(jsObj, 'isNewUser', object.isNewUser);
  IsarNative.jsObjectSet(jsObj, 'languageId', object.languageId);
  IsarNative.jsObjectSet(jsObj, 'name', object.name);
  IsarNative.jsObjectSet(jsObj, 'phoneno', object.phoneno);
  IsarNative.jsObjectSet(jsObj, 'utcLastUpdated',
      object.utcLastUpdated.toUtc().millisecondsSinceEpoch);
  return jsObj;
}

UserSetting _userSettingDeserializeWeb(
    IsarCollection<UserSetting> collection, dynamic jsObj) {
  final object = UserSetting(
    isDarkMode: IsarNative.jsObjectGet(jsObj, 'isDarkMode'),
    isNewUser: IsarNative.jsObjectGet(jsObj, 'isNewUser') ?? false,
    languageId: IsarNative.jsObjectGet(jsObj, 'languageId'),
    name: IsarNative.jsObjectGet(jsObj, 'name'),
    phoneno: IsarNative.jsObjectGet(jsObj, 'phoneno'),
    utcLastUpdated: IsarNative.jsObjectGet(jsObj, 'utcLastUpdated') != null
        ? DateTime.fromMillisecondsSinceEpoch(
                IsarNative.jsObjectGet(jsObj, 'utcLastUpdated'),
                isUtc: true)
            .toLocal()
        : DateTime.fromMillisecondsSinceEpoch(0),
  );
  object.id = IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity;
  return object;
}

P _userSettingDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
          as P;
    case 'isDarkMode':
      return (IsarNative.jsObjectGet(jsObj, 'isDarkMode')) as P;
    case 'isNewUser':
      return (IsarNative.jsObjectGet(jsObj, 'isNewUser') ?? false) as P;
    case 'languageId':
      return (IsarNative.jsObjectGet(jsObj, 'languageId')) as P;
    case 'name':
      return (IsarNative.jsObjectGet(jsObj, 'name')) as P;
    case 'phoneno':
      return (IsarNative.jsObjectGet(jsObj, 'phoneno')) as P;
    case 'utcLastUpdated':
      return (IsarNative.jsObjectGet(jsObj, 'utcLastUpdated') != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  IsarNative.jsObjectGet(jsObj, 'utcLastUpdated'),
                  isUtc: true)
              .toLocal()
          : DateTime.fromMillisecondsSinceEpoch(0)) as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _userSettingAttachLinks(IsarCollection col, int id, UserSetting object) {}

extension UserSettingQueryWhereSort
    on QueryBuilder<UserSetting, UserSetting, QWhere> {
  QueryBuilder<UserSetting, UserSetting, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }
}

extension UserSettingQueryWhere
    on QueryBuilder<UserSetting, UserSetting, QWhereClause> {
  QueryBuilder<UserSetting, UserSetting, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterWhereClause> idNotEqualTo(
      int id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      ).addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      );
    } else {
      return addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      ).addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      );
    }
  }

  QueryBuilder<UserSetting, UserSetting, QAfterWhereClause> idGreaterThan(
      int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<UserSetting, UserSetting, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<UserSetting, UserSetting, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: lowerId,
      includeLower: includeLower,
      upper: upperId,
      includeUpper: includeUpper,
    ));
  }
}

extension UserSettingQueryFilter
    on QueryBuilder<UserSetting, UserSetting, QFilterCondition> {
  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> idEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
      isDarkModeIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'isDarkMode',
      value: null,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
      isDarkModeEqualTo(bool? value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'isDarkMode',
      value: value,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
      isNewUserEqualTo(bool value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'isNewUser',
      value: value,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
      languageIdIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'languageId',
      value: null,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
      languageIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'languageId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
      languageIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'languageId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
      languageIdLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'languageId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
      languageIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'languageId',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
      languageIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'languageId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
      languageIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'languageId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
      languageIdContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'languageId',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
      languageIdMatches(String pattern, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'languageId',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> nameIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'name',
      value: null,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> nameGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> nameLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'name',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'name',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'name',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
      phonenoIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'phoneno',
      value: null,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> phonenoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'phoneno',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
      phonenoGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'phoneno',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> phonenoLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'phoneno',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> phonenoBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'phoneno',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
      phonenoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'phoneno',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> phonenoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'phoneno',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> phonenoContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'phoneno',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition> phonenoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'phoneno',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
      utcLastUpdatedEqualTo(DateTime value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'utcLastUpdated',
      value: value,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
      utcLastUpdatedGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'utcLastUpdated',
      value: value,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
      utcLastUpdatedLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'utcLastUpdated',
      value: value,
    ));
  }

  QueryBuilder<UserSetting, UserSetting, QAfterFilterCondition>
      utcLastUpdatedBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'utcLastUpdated',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }
}

extension UserSettingQueryLinks
    on QueryBuilder<UserSetting, UserSetting, QFilterCondition> {}

extension UserSettingQueryWhereSortBy
    on QueryBuilder<UserSetting, UserSetting, QSortBy> {
  QueryBuilder<UserSetting, UserSetting, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<UserSetting, UserSetting, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<UserSetting, UserSetting, QAfterSortBy> sortByIsDarkMode() {
    return addSortByInternal('isDarkMode', Sort.asc);
  }

  QueryBuilder<UserSetting, UserSetting, QAfterSortBy> sortByIsDarkModeDesc() {
    return addSortByInternal('isDarkMode', Sort.desc);
  }

  QueryBuilder<UserSetting, UserSetting, QAfterSortBy> sortByIsNewUser() {
    return addSortByInternal('isNewUser', Sort.asc);
  }

  QueryBuilder<UserSetting, UserSetting, QAfterSortBy> sortByIsNewUserDesc() {
    return addSortByInternal('isNewUser', Sort.desc);
  }

  QueryBuilder<UserSetting, UserSetting, QAfterSortBy> sortByLanguageId() {
    return addSortByInternal('languageId', Sort.asc);
  }

  QueryBuilder<UserSetting, UserSetting, QAfterSortBy> sortByLanguageIdDesc() {
    return addSortByInternal('languageId', Sort.desc);
  }

  QueryBuilder<UserSetting, UserSetting, QAfterSortBy> sortByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<UserSetting, UserSetting, QAfterSortBy> sortByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<UserSetting, UserSetting, QAfterSortBy> sortByPhoneno() {
    return addSortByInternal('phoneno', Sort.asc);
  }

  QueryBuilder<UserSetting, UserSetting, QAfterSortBy> sortByPhonenoDesc() {
    return addSortByInternal('phoneno', Sort.desc);
  }

  QueryBuilder<UserSetting, UserSetting, QAfterSortBy> sortByUtcLastUpdated() {
    return addSortByInternal('utcLastUpdated', Sort.asc);
  }

  QueryBuilder<UserSetting, UserSetting, QAfterSortBy>
      sortByUtcLastUpdatedDesc() {
    return addSortByInternal('utcLastUpdated', Sort.desc);
  }
}

extension UserSettingQueryWhereSortThenBy
    on QueryBuilder<UserSetting, UserSetting, QSortThenBy> {
  QueryBuilder<UserSetting, UserSetting, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<UserSetting, UserSetting, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<UserSetting, UserSetting, QAfterSortBy> thenByIsDarkMode() {
    return addSortByInternal('isDarkMode', Sort.asc);
  }

  QueryBuilder<UserSetting, UserSetting, QAfterSortBy> thenByIsDarkModeDesc() {
    return addSortByInternal('isDarkMode', Sort.desc);
  }

  QueryBuilder<UserSetting, UserSetting, QAfterSortBy> thenByIsNewUser() {
    return addSortByInternal('isNewUser', Sort.asc);
  }

  QueryBuilder<UserSetting, UserSetting, QAfterSortBy> thenByIsNewUserDesc() {
    return addSortByInternal('isNewUser', Sort.desc);
  }

  QueryBuilder<UserSetting, UserSetting, QAfterSortBy> thenByLanguageId() {
    return addSortByInternal('languageId', Sort.asc);
  }

  QueryBuilder<UserSetting, UserSetting, QAfterSortBy> thenByLanguageIdDesc() {
    return addSortByInternal('languageId', Sort.desc);
  }

  QueryBuilder<UserSetting, UserSetting, QAfterSortBy> thenByName() {
    return addSortByInternal('name', Sort.asc);
  }

  QueryBuilder<UserSetting, UserSetting, QAfterSortBy> thenByNameDesc() {
    return addSortByInternal('name', Sort.desc);
  }

  QueryBuilder<UserSetting, UserSetting, QAfterSortBy> thenByPhoneno() {
    return addSortByInternal('phoneno', Sort.asc);
  }

  QueryBuilder<UserSetting, UserSetting, QAfterSortBy> thenByPhonenoDesc() {
    return addSortByInternal('phoneno', Sort.desc);
  }

  QueryBuilder<UserSetting, UserSetting, QAfterSortBy> thenByUtcLastUpdated() {
    return addSortByInternal('utcLastUpdated', Sort.asc);
  }

  QueryBuilder<UserSetting, UserSetting, QAfterSortBy>
      thenByUtcLastUpdatedDesc() {
    return addSortByInternal('utcLastUpdated', Sort.desc);
  }
}

extension UserSettingQueryWhereDistinct
    on QueryBuilder<UserSetting, UserSetting, QDistinct> {
  QueryBuilder<UserSetting, UserSetting, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<UserSetting, UserSetting, QDistinct> distinctByIsDarkMode() {
    return addDistinctByInternal('isDarkMode');
  }

  QueryBuilder<UserSetting, UserSetting, QDistinct> distinctByIsNewUser() {
    return addDistinctByInternal('isNewUser');
  }

  QueryBuilder<UserSetting, UserSetting, QDistinct> distinctByLanguageId(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('languageId', caseSensitive: caseSensitive);
  }

  QueryBuilder<UserSetting, UserSetting, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('name', caseSensitive: caseSensitive);
  }

  QueryBuilder<UserSetting, UserSetting, QDistinct> distinctByPhoneno(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('phoneno', caseSensitive: caseSensitive);
  }

  QueryBuilder<UserSetting, UserSetting, QDistinct> distinctByUtcLastUpdated() {
    return addDistinctByInternal('utcLastUpdated');
  }
}

extension UserSettingQueryProperty
    on QueryBuilder<UserSetting, UserSetting, QQueryProperty> {
  QueryBuilder<UserSetting, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<UserSetting, bool?, QQueryOperations> isDarkModeProperty() {
    return addPropertyNameInternal('isDarkMode');
  }

  QueryBuilder<UserSetting, bool, QQueryOperations> isNewUserProperty() {
    return addPropertyNameInternal('isNewUser');
  }

  QueryBuilder<UserSetting, String?, QQueryOperations> languageIdProperty() {
    return addPropertyNameInternal('languageId');
  }

  QueryBuilder<UserSetting, String?, QQueryOperations> nameProperty() {
    return addPropertyNameInternal('name');
  }

  QueryBuilder<UserSetting, String?, QQueryOperations> phonenoProperty() {
    return addPropertyNameInternal('phoneno');
  }

  QueryBuilder<UserSetting, DateTime, QQueryOperations>
      utcLastUpdatedProperty() {
    return addPropertyNameInternal('utcLastUpdated');
  }
}
