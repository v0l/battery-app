// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'battery.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthOutcome {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthOutcome);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthOutcome()';
}


}

/// @nodoc
class $AuthOutcomeCopyWith<$Res>  {
$AuthOutcomeCopyWith(AuthOutcome _, $Res Function(AuthOutcome) __);
}


/// Adds pattern-matching-related methods to [AuthOutcome].
extension AuthOutcomePatterns on AuthOutcome {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AuthOutcome_Authed value)?  authed,TResult Function( AuthOutcome_PendingApproval value)?  pendingApproval,TResult Function( AuthOutcome_PinCode value)?  pinCode,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AuthOutcome_Authed() when authed != null:
return authed(_that);case AuthOutcome_PendingApproval() when pendingApproval != null:
return pendingApproval(_that);case AuthOutcome_PinCode() when pinCode != null:
return pinCode(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AuthOutcome_Authed value)  authed,required TResult Function( AuthOutcome_PendingApproval value)  pendingApproval,required TResult Function( AuthOutcome_PinCode value)  pinCode,}){
final _that = this;
switch (_that) {
case AuthOutcome_Authed():
return authed(_that);case AuthOutcome_PendingApproval():
return pendingApproval(_that);case AuthOutcome_PinCode():
return pinCode(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AuthOutcome_Authed value)?  authed,TResult? Function( AuthOutcome_PendingApproval value)?  pendingApproval,TResult? Function( AuthOutcome_PinCode value)?  pinCode,}){
final _that = this;
switch (_that) {
case AuthOutcome_Authed() when authed != null:
return authed(_that);case AuthOutcome_PendingApproval() when pendingApproval != null:
return pendingApproval(_that);case AuthOutcome_PinCode() when pinCode != null:
return pinCode(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  authed,TResult Function( String message)?  pendingApproval,TResult Function( String message)?  pinCode,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AuthOutcome_Authed() when authed != null:
return authed();case AuthOutcome_PendingApproval() when pendingApproval != null:
return pendingApproval(_that.message);case AuthOutcome_PinCode() when pinCode != null:
return pinCode(_that.message);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  authed,required TResult Function( String message)  pendingApproval,required TResult Function( String message)  pinCode,}) {final _that = this;
switch (_that) {
case AuthOutcome_Authed():
return authed();case AuthOutcome_PendingApproval():
return pendingApproval(_that.message);case AuthOutcome_PinCode():
return pinCode(_that.message);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  authed,TResult? Function( String message)?  pendingApproval,TResult? Function( String message)?  pinCode,}) {final _that = this;
switch (_that) {
case AuthOutcome_Authed() when authed != null:
return authed();case AuthOutcome_PendingApproval() when pendingApproval != null:
return pendingApproval(_that.message);case AuthOutcome_PinCode() when pinCode != null:
return pinCode(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class AuthOutcome_Authed extends AuthOutcome {
  const AuthOutcome_Authed(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthOutcome_Authed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthOutcome.authed()';
}


}




/// @nodoc


class AuthOutcome_PendingApproval extends AuthOutcome {
  const AuthOutcome_PendingApproval({required this.message}): super._();
  

 final  String message;

/// Create a copy of AuthOutcome
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthOutcome_PendingApprovalCopyWith<AuthOutcome_PendingApproval> get copyWith => _$AuthOutcome_PendingApprovalCopyWithImpl<AuthOutcome_PendingApproval>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthOutcome_PendingApproval&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthOutcome.pendingApproval(message: $message)';
}


}

/// @nodoc
abstract mixin class $AuthOutcome_PendingApprovalCopyWith<$Res> implements $AuthOutcomeCopyWith<$Res> {
  factory $AuthOutcome_PendingApprovalCopyWith(AuthOutcome_PendingApproval value, $Res Function(AuthOutcome_PendingApproval) _then) = _$AuthOutcome_PendingApprovalCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AuthOutcome_PendingApprovalCopyWithImpl<$Res>
    implements $AuthOutcome_PendingApprovalCopyWith<$Res> {
  _$AuthOutcome_PendingApprovalCopyWithImpl(this._self, this._then);

  final AuthOutcome_PendingApproval _self;
  final $Res Function(AuthOutcome_PendingApproval) _then;

/// Create a copy of AuthOutcome
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AuthOutcome_PendingApproval(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AuthOutcome_PinCode extends AuthOutcome {
  const AuthOutcome_PinCode({required this.message}): super._();
  

 final  String message;

/// Create a copy of AuthOutcome
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthOutcome_PinCodeCopyWith<AuthOutcome_PinCode> get copyWith => _$AuthOutcome_PinCodeCopyWithImpl<AuthOutcome_PinCode>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthOutcome_PinCode&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthOutcome.pinCode(message: $message)';
}


}

/// @nodoc
abstract mixin class $AuthOutcome_PinCodeCopyWith<$Res> implements $AuthOutcomeCopyWith<$Res> {
  factory $AuthOutcome_PinCodeCopyWith(AuthOutcome_PinCode value, $Res Function(AuthOutcome_PinCode) _then) = _$AuthOutcome_PinCodeCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AuthOutcome_PinCodeCopyWithImpl<$Res>
    implements $AuthOutcome_PinCodeCopyWith<$Res> {
  _$AuthOutcome_PinCodeCopyWithImpl(this._self, this._then);

  final AuthOutcome_PinCode _self;
  final $Res Function(AuthOutcome_PinCode) _then;

/// Create a copy of AuthOutcome
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AuthOutcome_PinCode(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$SettingKind {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingKind);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingKind()';
}


}

/// @nodoc
class $SettingKindCopyWith<$Res>  {
$SettingKindCopyWith(SettingKind _, $Res Function(SettingKind) __);
}


/// Adds pattern-matching-related methods to [SettingKind].
extension SettingKindPatterns on SettingKind {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SettingKind_Bool value)?  bool,TResult Function( SettingKind_Number value)?  number,TResult Function( SettingKind_Enum value)?  enum_,TResult Function( SettingKind_Text value)?  text,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SettingKind_Bool() when bool != null:
return bool(_that);case SettingKind_Number() when number != null:
return number(_that);case SettingKind_Enum() when enum_ != null:
return enum_(_that);case SettingKind_Text() when text != null:
return text(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SettingKind_Bool value)  bool,required TResult Function( SettingKind_Number value)  number,required TResult Function( SettingKind_Enum value)  enum_,required TResult Function( SettingKind_Text value)  text,}){
final _that = this;
switch (_that) {
case SettingKind_Bool():
return bool(_that);case SettingKind_Number():
return number(_that);case SettingKind_Enum():
return enum_(_that);case SettingKind_Text():
return text(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SettingKind_Bool value)?  bool,TResult? Function( SettingKind_Number value)?  number,TResult? Function( SettingKind_Enum value)?  enum_,TResult? Function( SettingKind_Text value)?  text,}){
final _that = this;
switch (_that) {
case SettingKind_Bool() when bool != null:
return bool(_that);case SettingKind_Number() when number != null:
return number(_that);case SettingKind_Enum() when enum_ != null:
return enum_(_that);case SettingKind_Text() when text != null:
return text(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  bool,TResult Function( double? min,  double? max,  double? step,  String unit)?  number,TResult Function( List<SettingOptionDart> options)?  enum_,TResult Function()?  text,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SettingKind_Bool() when bool != null:
return bool();case SettingKind_Number() when number != null:
return number(_that.min,_that.max,_that.step,_that.unit);case SettingKind_Enum() when enum_ != null:
return enum_(_that.options);case SettingKind_Text() when text != null:
return text();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  bool,required TResult Function( double? min,  double? max,  double? step,  String unit)  number,required TResult Function( List<SettingOptionDart> options)  enum_,required TResult Function()  text,}) {final _that = this;
switch (_that) {
case SettingKind_Bool():
return bool();case SettingKind_Number():
return number(_that.min,_that.max,_that.step,_that.unit);case SettingKind_Enum():
return enum_(_that.options);case SettingKind_Text():
return text();}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  bool,TResult? Function( double? min,  double? max,  double? step,  String unit)?  number,TResult? Function( List<SettingOptionDart> options)?  enum_,TResult? Function()?  text,}) {final _that = this;
switch (_that) {
case SettingKind_Bool() when bool != null:
return bool();case SettingKind_Number() when number != null:
return number(_that.min,_that.max,_that.step,_that.unit);case SettingKind_Enum() when enum_ != null:
return enum_(_that.options);case SettingKind_Text() when text != null:
return text();case _:
  return null;

}
}

}

/// @nodoc


class SettingKind_Bool extends SettingKind {
  const SettingKind_Bool(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingKind_Bool);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingKind.bool()';
}


}




/// @nodoc


class SettingKind_Number extends SettingKind {
  const SettingKind_Number({this.min, this.max, this.step, required this.unit}): super._();
  

 final  double? min;
 final  double? max;
 final  double? step;
 final  String unit;

/// Create a copy of SettingKind
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingKind_NumberCopyWith<SettingKind_Number> get copyWith => _$SettingKind_NumberCopyWithImpl<SettingKind_Number>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingKind_Number&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max)&&(identical(other.step, step) || other.step == step)&&(identical(other.unit, unit) || other.unit == unit));
}


@override
int get hashCode => Object.hash(runtimeType,min,max,step,unit);

@override
String toString() {
  return 'SettingKind.number(min: $min, max: $max, step: $step, unit: $unit)';
}


}

/// @nodoc
abstract mixin class $SettingKind_NumberCopyWith<$Res> implements $SettingKindCopyWith<$Res> {
  factory $SettingKind_NumberCopyWith(SettingKind_Number value, $Res Function(SettingKind_Number) _then) = _$SettingKind_NumberCopyWithImpl;
@useResult
$Res call({
 double? min, double? max, double? step, String unit
});




}
/// @nodoc
class _$SettingKind_NumberCopyWithImpl<$Res>
    implements $SettingKind_NumberCopyWith<$Res> {
  _$SettingKind_NumberCopyWithImpl(this._self, this._then);

  final SettingKind_Number _self;
  final $Res Function(SettingKind_Number) _then;

/// Create a copy of SettingKind
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? min = freezed,Object? max = freezed,Object? step = freezed,Object? unit = null,}) {
  return _then(SettingKind_Number(
min: freezed == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as double?,max: freezed == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as double?,step: freezed == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as double?,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SettingKind_Enum extends SettingKind {
  const SettingKind_Enum({required final  List<SettingOptionDart> options}): _options = options,super._();
  

 final  List<SettingOptionDart> _options;
 List<SettingOptionDart> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}


/// Create a copy of SettingKind
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingKind_EnumCopyWith<SettingKind_Enum> get copyWith => _$SettingKind_EnumCopyWithImpl<SettingKind_Enum>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingKind_Enum&&const DeepCollectionEquality().equals(other._options, _options));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_options));

@override
String toString() {
  return 'SettingKind.enum_(options: $options)';
}


}

/// @nodoc
abstract mixin class $SettingKind_EnumCopyWith<$Res> implements $SettingKindCopyWith<$Res> {
  factory $SettingKind_EnumCopyWith(SettingKind_Enum value, $Res Function(SettingKind_Enum) _then) = _$SettingKind_EnumCopyWithImpl;
@useResult
$Res call({
 List<SettingOptionDart> options
});




}
/// @nodoc
class _$SettingKind_EnumCopyWithImpl<$Res>
    implements $SettingKind_EnumCopyWith<$Res> {
  _$SettingKind_EnumCopyWithImpl(this._self, this._then);

  final SettingKind_Enum _self;
  final $Res Function(SettingKind_Enum) _then;

/// Create a copy of SettingKind
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? options = null,}) {
  return _then(SettingKind_Enum(
options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<SettingOptionDart>,
  ));
}


}

/// @nodoc


class SettingKind_Text extends SettingKind {
  const SettingKind_Text(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingKind_Text);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingKind.text()';
}


}




/// @nodoc
mixin _$SettingValue {

 Object get field0;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingValue&&const DeepCollectionEquality().equals(other.field0, field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(field0));

@override
String toString() {
  return 'SettingValue(field0: $field0)';
}


}

/// @nodoc
class $SettingValueCopyWith<$Res>  {
$SettingValueCopyWith(SettingValue _, $Res Function(SettingValue) __);
}


/// Adds pattern-matching-related methods to [SettingValue].
extension SettingValuePatterns on SettingValue {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SettingValue_Bool value)?  bool,TResult Function( SettingValue_Number value)?  number,TResult Function( SettingValue_Text value)?  text,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SettingValue_Bool() when bool != null:
return bool(_that);case SettingValue_Number() when number != null:
return number(_that);case SettingValue_Text() when text != null:
return text(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SettingValue_Bool value)  bool,required TResult Function( SettingValue_Number value)  number,required TResult Function( SettingValue_Text value)  text,}){
final _that = this;
switch (_that) {
case SettingValue_Bool():
return bool(_that);case SettingValue_Number():
return number(_that);case SettingValue_Text():
return text(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SettingValue_Bool value)?  bool,TResult? Function( SettingValue_Number value)?  number,TResult? Function( SettingValue_Text value)?  text,}){
final _that = this;
switch (_that) {
case SettingValue_Bool() when bool != null:
return bool(_that);case SettingValue_Number() when number != null:
return number(_that);case SettingValue_Text() when text != null:
return text(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool field0)?  bool,TResult Function( double field0)?  number,TResult Function( String field0)?  text,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SettingValue_Bool() when bool != null:
return bool(_that.field0);case SettingValue_Number() when number != null:
return number(_that.field0);case SettingValue_Text() when text != null:
return text(_that.field0);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool field0)  bool,required TResult Function( double field0)  number,required TResult Function( String field0)  text,}) {final _that = this;
switch (_that) {
case SettingValue_Bool():
return bool(_that.field0);case SettingValue_Number():
return number(_that.field0);case SettingValue_Text():
return text(_that.field0);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool field0)?  bool,TResult? Function( double field0)?  number,TResult? Function( String field0)?  text,}) {final _that = this;
switch (_that) {
case SettingValue_Bool() when bool != null:
return bool(_that.field0);case SettingValue_Number() when number != null:
return number(_that.field0);case SettingValue_Text() when text != null:
return text(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class SettingValue_Bool extends SettingValue {
  const SettingValue_Bool(this.field0): super._();
  

@override final  bool field0;

/// Create a copy of SettingValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingValue_BoolCopyWith<SettingValue_Bool> get copyWith => _$SettingValue_BoolCopyWithImpl<SettingValue_Bool>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingValue_Bool&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'SettingValue.bool(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $SettingValue_BoolCopyWith<$Res> implements $SettingValueCopyWith<$Res> {
  factory $SettingValue_BoolCopyWith(SettingValue_Bool value, $Res Function(SettingValue_Bool) _then) = _$SettingValue_BoolCopyWithImpl;
@useResult
$Res call({
 bool field0
});




}
/// @nodoc
class _$SettingValue_BoolCopyWithImpl<$Res>
    implements $SettingValue_BoolCopyWith<$Res> {
  _$SettingValue_BoolCopyWithImpl(this._self, this._then);

  final SettingValue_Bool _self;
  final $Res Function(SettingValue_Bool) _then;

/// Create a copy of SettingValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(SettingValue_Bool(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class SettingValue_Number extends SettingValue {
  const SettingValue_Number(this.field0): super._();
  

@override final  double field0;

/// Create a copy of SettingValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingValue_NumberCopyWith<SettingValue_Number> get copyWith => _$SettingValue_NumberCopyWithImpl<SettingValue_Number>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingValue_Number&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'SettingValue.number(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $SettingValue_NumberCopyWith<$Res> implements $SettingValueCopyWith<$Res> {
  factory $SettingValue_NumberCopyWith(SettingValue_Number value, $Res Function(SettingValue_Number) _then) = _$SettingValue_NumberCopyWithImpl;
@useResult
$Res call({
 double field0
});




}
/// @nodoc
class _$SettingValue_NumberCopyWithImpl<$Res>
    implements $SettingValue_NumberCopyWith<$Res> {
  _$SettingValue_NumberCopyWithImpl(this._self, this._then);

  final SettingValue_Number _self;
  final $Res Function(SettingValue_Number) _then;

/// Create a copy of SettingValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(SettingValue_Number(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class SettingValue_Text extends SettingValue {
  const SettingValue_Text(this.field0): super._();
  

@override final  String field0;

/// Create a copy of SettingValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingValue_TextCopyWith<SettingValue_Text> get copyWith => _$SettingValue_TextCopyWithImpl<SettingValue_Text>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingValue_Text&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'SettingValue.text(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $SettingValue_TextCopyWith<$Res> implements $SettingValueCopyWith<$Res> {
  factory $SettingValue_TextCopyWith(SettingValue_Text value, $Res Function(SettingValue_Text) _then) = _$SettingValue_TextCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$SettingValue_TextCopyWithImpl<$Res>
    implements $SettingValue_TextCopyWith<$Res> {
  _$SettingValue_TextCopyWithImpl(this._self, this._then);

  final SettingValue_Text _self;
  final $Res Function(SettingValue_Text) _then;

/// Create a copy of SettingValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(SettingValue_Text(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$StatusUpdate {

 Object get field0;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatusUpdate&&const DeepCollectionEquality().equals(other.field0, field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(field0));

@override
String toString() {
  return 'StatusUpdate(field0: $field0)';
}


}

/// @nodoc
class $StatusUpdateCopyWith<$Res>  {
$StatusUpdateCopyWith(StatusUpdate _, $Res Function(StatusUpdate) __);
}


/// Adds pattern-matching-related methods to [StatusUpdate].
extension StatusUpdatePatterns on StatusUpdate {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( StatusUpdate_Sensor value)?  sensor,TResult Function( StatusUpdate_Switch value)?  switch_,TResult Function( StatusUpdate_Port value)?  port,TResult Function( StatusUpdate_Cell value)?  cell,TResult Function( StatusUpdate_Setting value)?  setting,TResult Function( StatusUpdate_Alarms value)?  alarms,required TResult orElse(),}){
final _that = this;
switch (_that) {
case StatusUpdate_Sensor() when sensor != null:
return sensor(_that);case StatusUpdate_Switch() when switch_ != null:
return switch_(_that);case StatusUpdate_Port() when port != null:
return port(_that);case StatusUpdate_Cell() when cell != null:
return cell(_that);case StatusUpdate_Setting() when setting != null:
return setting(_that);case StatusUpdate_Alarms() when alarms != null:
return alarms(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( StatusUpdate_Sensor value)  sensor,required TResult Function( StatusUpdate_Switch value)  switch_,required TResult Function( StatusUpdate_Port value)  port,required TResult Function( StatusUpdate_Cell value)  cell,required TResult Function( StatusUpdate_Setting value)  setting,required TResult Function( StatusUpdate_Alarms value)  alarms,}){
final _that = this;
switch (_that) {
case StatusUpdate_Sensor():
return sensor(_that);case StatusUpdate_Switch():
return switch_(_that);case StatusUpdate_Port():
return port(_that);case StatusUpdate_Cell():
return cell(_that);case StatusUpdate_Setting():
return setting(_that);case StatusUpdate_Alarms():
return alarms(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( StatusUpdate_Sensor value)?  sensor,TResult? Function( StatusUpdate_Switch value)?  switch_,TResult? Function( StatusUpdate_Port value)?  port,TResult? Function( StatusUpdate_Cell value)?  cell,TResult? Function( StatusUpdate_Setting value)?  setting,TResult? Function( StatusUpdate_Alarms value)?  alarms,}){
final _that = this;
switch (_that) {
case StatusUpdate_Sensor() when sensor != null:
return sensor(_that);case StatusUpdate_Switch() when switch_ != null:
return switch_(_that);case StatusUpdate_Port() when port != null:
return port(_that);case StatusUpdate_Cell() when cell != null:
return cell(_that);case StatusUpdate_Setting() when setting != null:
return setting(_that);case StatusUpdate_Alarms() when alarms != null:
return alarms(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Sensor field0)?  sensor,TResult Function( Switch field0)?  switch_,TResult Function( PortInfo field0)?  port,TResult Function( CellInfo field0)?  cell,TResult Function( Setting field0)?  setting,TResult Function( List<String> field0)?  alarms,required TResult orElse(),}) {final _that = this;
switch (_that) {
case StatusUpdate_Sensor() when sensor != null:
return sensor(_that.field0);case StatusUpdate_Switch() when switch_ != null:
return switch_(_that.field0);case StatusUpdate_Port() when port != null:
return port(_that.field0);case StatusUpdate_Cell() when cell != null:
return cell(_that.field0);case StatusUpdate_Setting() when setting != null:
return setting(_that.field0);case StatusUpdate_Alarms() when alarms != null:
return alarms(_that.field0);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Sensor field0)  sensor,required TResult Function( Switch field0)  switch_,required TResult Function( PortInfo field0)  port,required TResult Function( CellInfo field0)  cell,required TResult Function( Setting field0)  setting,required TResult Function( List<String> field0)  alarms,}) {final _that = this;
switch (_that) {
case StatusUpdate_Sensor():
return sensor(_that.field0);case StatusUpdate_Switch():
return switch_(_that.field0);case StatusUpdate_Port():
return port(_that.field0);case StatusUpdate_Cell():
return cell(_that.field0);case StatusUpdate_Setting():
return setting(_that.field0);case StatusUpdate_Alarms():
return alarms(_that.field0);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Sensor field0)?  sensor,TResult? Function( Switch field0)?  switch_,TResult? Function( PortInfo field0)?  port,TResult? Function( CellInfo field0)?  cell,TResult? Function( Setting field0)?  setting,TResult? Function( List<String> field0)?  alarms,}) {final _that = this;
switch (_that) {
case StatusUpdate_Sensor() when sensor != null:
return sensor(_that.field0);case StatusUpdate_Switch() when switch_ != null:
return switch_(_that.field0);case StatusUpdate_Port() when port != null:
return port(_that.field0);case StatusUpdate_Cell() when cell != null:
return cell(_that.field0);case StatusUpdate_Setting() when setting != null:
return setting(_that.field0);case StatusUpdate_Alarms() when alarms != null:
return alarms(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class StatusUpdate_Sensor extends StatusUpdate {
  const StatusUpdate_Sensor(this.field0): super._();
  

@override final  Sensor field0;

/// Create a copy of StatusUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatusUpdate_SensorCopyWith<StatusUpdate_Sensor> get copyWith => _$StatusUpdate_SensorCopyWithImpl<StatusUpdate_Sensor>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatusUpdate_Sensor&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'StatusUpdate.sensor(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $StatusUpdate_SensorCopyWith<$Res> implements $StatusUpdateCopyWith<$Res> {
  factory $StatusUpdate_SensorCopyWith(StatusUpdate_Sensor value, $Res Function(StatusUpdate_Sensor) _then) = _$StatusUpdate_SensorCopyWithImpl;
@useResult
$Res call({
 Sensor field0
});




}
/// @nodoc
class _$StatusUpdate_SensorCopyWithImpl<$Res>
    implements $StatusUpdate_SensorCopyWith<$Res> {
  _$StatusUpdate_SensorCopyWithImpl(this._self, this._then);

  final StatusUpdate_Sensor _self;
  final $Res Function(StatusUpdate_Sensor) _then;

/// Create a copy of StatusUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(StatusUpdate_Sensor(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as Sensor,
  ));
}


}

/// @nodoc


class StatusUpdate_Switch extends StatusUpdate {
  const StatusUpdate_Switch(this.field0): super._();
  

@override final  Switch field0;

/// Create a copy of StatusUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatusUpdate_SwitchCopyWith<StatusUpdate_Switch> get copyWith => _$StatusUpdate_SwitchCopyWithImpl<StatusUpdate_Switch>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatusUpdate_Switch&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'StatusUpdate.switch_(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $StatusUpdate_SwitchCopyWith<$Res> implements $StatusUpdateCopyWith<$Res> {
  factory $StatusUpdate_SwitchCopyWith(StatusUpdate_Switch value, $Res Function(StatusUpdate_Switch) _then) = _$StatusUpdate_SwitchCopyWithImpl;
@useResult
$Res call({
 Switch field0
});




}
/// @nodoc
class _$StatusUpdate_SwitchCopyWithImpl<$Res>
    implements $StatusUpdate_SwitchCopyWith<$Res> {
  _$StatusUpdate_SwitchCopyWithImpl(this._self, this._then);

  final StatusUpdate_Switch _self;
  final $Res Function(StatusUpdate_Switch) _then;

/// Create a copy of StatusUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(StatusUpdate_Switch(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as Switch,
  ));
}


}

/// @nodoc


class StatusUpdate_Port extends StatusUpdate {
  const StatusUpdate_Port(this.field0): super._();
  

@override final  PortInfo field0;

/// Create a copy of StatusUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatusUpdate_PortCopyWith<StatusUpdate_Port> get copyWith => _$StatusUpdate_PortCopyWithImpl<StatusUpdate_Port>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatusUpdate_Port&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'StatusUpdate.port(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $StatusUpdate_PortCopyWith<$Res> implements $StatusUpdateCopyWith<$Res> {
  factory $StatusUpdate_PortCopyWith(StatusUpdate_Port value, $Res Function(StatusUpdate_Port) _then) = _$StatusUpdate_PortCopyWithImpl;
@useResult
$Res call({
 PortInfo field0
});




}
/// @nodoc
class _$StatusUpdate_PortCopyWithImpl<$Res>
    implements $StatusUpdate_PortCopyWith<$Res> {
  _$StatusUpdate_PortCopyWithImpl(this._self, this._then);

  final StatusUpdate_Port _self;
  final $Res Function(StatusUpdate_Port) _then;

/// Create a copy of StatusUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(StatusUpdate_Port(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as PortInfo,
  ));
}


}

/// @nodoc


class StatusUpdate_Cell extends StatusUpdate {
  const StatusUpdate_Cell(this.field0): super._();
  

@override final  CellInfo field0;

/// Create a copy of StatusUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatusUpdate_CellCopyWith<StatusUpdate_Cell> get copyWith => _$StatusUpdate_CellCopyWithImpl<StatusUpdate_Cell>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatusUpdate_Cell&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'StatusUpdate.cell(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $StatusUpdate_CellCopyWith<$Res> implements $StatusUpdateCopyWith<$Res> {
  factory $StatusUpdate_CellCopyWith(StatusUpdate_Cell value, $Res Function(StatusUpdate_Cell) _then) = _$StatusUpdate_CellCopyWithImpl;
@useResult
$Res call({
 CellInfo field0
});




}
/// @nodoc
class _$StatusUpdate_CellCopyWithImpl<$Res>
    implements $StatusUpdate_CellCopyWith<$Res> {
  _$StatusUpdate_CellCopyWithImpl(this._self, this._then);

  final StatusUpdate_Cell _self;
  final $Res Function(StatusUpdate_Cell) _then;

/// Create a copy of StatusUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(StatusUpdate_Cell(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as CellInfo,
  ));
}


}

/// @nodoc


class StatusUpdate_Setting extends StatusUpdate {
  const StatusUpdate_Setting(this.field0): super._();
  

@override final  Setting field0;

/// Create a copy of StatusUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatusUpdate_SettingCopyWith<StatusUpdate_Setting> get copyWith => _$StatusUpdate_SettingCopyWithImpl<StatusUpdate_Setting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatusUpdate_Setting&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'StatusUpdate.setting(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $StatusUpdate_SettingCopyWith<$Res> implements $StatusUpdateCopyWith<$Res> {
  factory $StatusUpdate_SettingCopyWith(StatusUpdate_Setting value, $Res Function(StatusUpdate_Setting) _then) = _$StatusUpdate_SettingCopyWithImpl;
@useResult
$Res call({
 Setting field0
});




}
/// @nodoc
class _$StatusUpdate_SettingCopyWithImpl<$Res>
    implements $StatusUpdate_SettingCopyWith<$Res> {
  _$StatusUpdate_SettingCopyWithImpl(this._self, this._then);

  final StatusUpdate_Setting _self;
  final $Res Function(StatusUpdate_Setting) _then;

/// Create a copy of StatusUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(StatusUpdate_Setting(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as Setting,
  ));
}


}

/// @nodoc


class StatusUpdate_Alarms extends StatusUpdate {
  const StatusUpdate_Alarms(final  List<String> field0): _field0 = field0,super._();
  

 final  List<String> _field0;
@override List<String> get field0 {
  if (_field0 is EqualUnmodifiableListView) return _field0;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_field0);
}


/// Create a copy of StatusUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatusUpdate_AlarmsCopyWith<StatusUpdate_Alarms> get copyWith => _$StatusUpdate_AlarmsCopyWithImpl<StatusUpdate_Alarms>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatusUpdate_Alarms&&const DeepCollectionEquality().equals(other._field0, _field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_field0));

@override
String toString() {
  return 'StatusUpdate.alarms(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $StatusUpdate_AlarmsCopyWith<$Res> implements $StatusUpdateCopyWith<$Res> {
  factory $StatusUpdate_AlarmsCopyWith(StatusUpdate_Alarms value, $Res Function(StatusUpdate_Alarms) _then) = _$StatusUpdate_AlarmsCopyWithImpl;
@useResult
$Res call({
 List<String> field0
});




}
/// @nodoc
class _$StatusUpdate_AlarmsCopyWithImpl<$Res>
    implements $StatusUpdate_AlarmsCopyWith<$Res> {
  _$StatusUpdate_AlarmsCopyWithImpl(this._self, this._then);

  final StatusUpdate_Alarms _self;
  final $Res Function(StatusUpdate_Alarms) _then;

/// Create a copy of StatusUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(StatusUpdate_Alarms(
null == field0 ? _self._field0 : field0 // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$StreamEvent {

 Object get field0;



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StreamEvent&&const DeepCollectionEquality().equals(other.field0, field0));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(field0));

@override
String toString() {
  return 'StreamEvent(field0: $field0)';
}


}

/// @nodoc
class $StreamEventCopyWith<$Res>  {
$StreamEventCopyWith(StreamEvent _, $Res Function(StreamEvent) __);
}


/// Adds pattern-matching-related methods to [StreamEvent].
extension StreamEventPatterns on StreamEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( StreamEvent_Snapshot value)?  snapshot,TResult Function( StreamEvent_Update value)?  update,TResult Function( StreamEvent_Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case StreamEvent_Snapshot() when snapshot != null:
return snapshot(_that);case StreamEvent_Update() when update != null:
return update(_that);case StreamEvent_Error() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( StreamEvent_Snapshot value)  snapshot,required TResult Function( StreamEvent_Update value)  update,required TResult Function( StreamEvent_Error value)  error,}){
final _that = this;
switch (_that) {
case StreamEvent_Snapshot():
return snapshot(_that);case StreamEvent_Update():
return update(_that);case StreamEvent_Error():
return error(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( StreamEvent_Snapshot value)?  snapshot,TResult? Function( StreamEvent_Update value)?  update,TResult? Function( StreamEvent_Error value)?  error,}){
final _that = this;
switch (_that) {
case StreamEvent_Snapshot() when snapshot != null:
return snapshot(_that);case StreamEvent_Update() when update != null:
return update(_that);case StreamEvent_Error() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( BatteryStatus field0)?  snapshot,TResult Function( StatusUpdate field0)?  update,TResult Function( String field0)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case StreamEvent_Snapshot() when snapshot != null:
return snapshot(_that.field0);case StreamEvent_Update() when update != null:
return update(_that.field0);case StreamEvent_Error() when error != null:
return error(_that.field0);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( BatteryStatus field0)  snapshot,required TResult Function( StatusUpdate field0)  update,required TResult Function( String field0)  error,}) {final _that = this;
switch (_that) {
case StreamEvent_Snapshot():
return snapshot(_that.field0);case StreamEvent_Update():
return update(_that.field0);case StreamEvent_Error():
return error(_that.field0);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( BatteryStatus field0)?  snapshot,TResult? Function( StatusUpdate field0)?  update,TResult? Function( String field0)?  error,}) {final _that = this;
switch (_that) {
case StreamEvent_Snapshot() when snapshot != null:
return snapshot(_that.field0);case StreamEvent_Update() when update != null:
return update(_that.field0);case StreamEvent_Error() when error != null:
return error(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class StreamEvent_Snapshot extends StreamEvent {
  const StreamEvent_Snapshot(this.field0): super._();
  

@override final  BatteryStatus field0;

/// Create a copy of StreamEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StreamEvent_SnapshotCopyWith<StreamEvent_Snapshot> get copyWith => _$StreamEvent_SnapshotCopyWithImpl<StreamEvent_Snapshot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StreamEvent_Snapshot&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'StreamEvent.snapshot(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $StreamEvent_SnapshotCopyWith<$Res> implements $StreamEventCopyWith<$Res> {
  factory $StreamEvent_SnapshotCopyWith(StreamEvent_Snapshot value, $Res Function(StreamEvent_Snapshot) _then) = _$StreamEvent_SnapshotCopyWithImpl;
@useResult
$Res call({
 BatteryStatus field0
});




}
/// @nodoc
class _$StreamEvent_SnapshotCopyWithImpl<$Res>
    implements $StreamEvent_SnapshotCopyWith<$Res> {
  _$StreamEvent_SnapshotCopyWithImpl(this._self, this._then);

  final StreamEvent_Snapshot _self;
  final $Res Function(StreamEvent_Snapshot) _then;

/// Create a copy of StreamEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(StreamEvent_Snapshot(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as BatteryStatus,
  ));
}


}

/// @nodoc


class StreamEvent_Update extends StreamEvent {
  const StreamEvent_Update(this.field0): super._();
  

@override final  StatusUpdate field0;

/// Create a copy of StreamEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StreamEvent_UpdateCopyWith<StreamEvent_Update> get copyWith => _$StreamEvent_UpdateCopyWithImpl<StreamEvent_Update>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StreamEvent_Update&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'StreamEvent.update(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $StreamEvent_UpdateCopyWith<$Res> implements $StreamEventCopyWith<$Res> {
  factory $StreamEvent_UpdateCopyWith(StreamEvent_Update value, $Res Function(StreamEvent_Update) _then) = _$StreamEvent_UpdateCopyWithImpl;
@useResult
$Res call({
 StatusUpdate field0
});


$StatusUpdateCopyWith<$Res> get field0;

}
/// @nodoc
class _$StreamEvent_UpdateCopyWithImpl<$Res>
    implements $StreamEvent_UpdateCopyWith<$Res> {
  _$StreamEvent_UpdateCopyWithImpl(this._self, this._then);

  final StreamEvent_Update _self;
  final $Res Function(StreamEvent_Update) _then;

/// Create a copy of StreamEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(StreamEvent_Update(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as StatusUpdate,
  ));
}

/// Create a copy of StreamEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatusUpdateCopyWith<$Res> get field0 {
  
  return $StatusUpdateCopyWith<$Res>(_self.field0, (value) {
    return _then(_self.copyWith(field0: value));
  });
}
}

/// @nodoc


class StreamEvent_Error extends StreamEvent {
  const StreamEvent_Error(this.field0): super._();
  

@override final  String field0;

/// Create a copy of StreamEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StreamEvent_ErrorCopyWith<StreamEvent_Error> get copyWith => _$StreamEvent_ErrorCopyWithImpl<StreamEvent_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StreamEvent_Error&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode => Object.hash(runtimeType,field0);

@override
String toString() {
  return 'StreamEvent.error(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $StreamEvent_ErrorCopyWith<$Res> implements $StreamEventCopyWith<$Res> {
  factory $StreamEvent_ErrorCopyWith(StreamEvent_Error value, $Res Function(StreamEvent_Error) _then) = _$StreamEvent_ErrorCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$StreamEvent_ErrorCopyWithImpl<$Res>
    implements $StreamEvent_ErrorCopyWith<$Res> {
  _$StreamEvent_ErrorCopyWithImpl(this._self, this._then);

  final StreamEvent_Error _self;
  final $Res Function(StreamEvent_Error) _then;

/// Create a copy of StreamEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(StreamEvent_Error(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
