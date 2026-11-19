import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/permission_codes.dart';
import '../../../core/errors/failures.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/iranian_national_id.dart';
import '../../../core/utils/responsive.dart';
import '../../../domain/entities/employee_entity.dart';
import '../../../domain/usecases/employee/employee_usecases.dart';
import '../../providers/repository_providers.dart';
import '../../widgets/common/gaz_jalali_date_field.dart';
import '../../widgets/common/permission_gate.dart';
import 'employee_documents_tab.dart';
import 'employee_list_screen.dart';

final employeeDetailProvider =
    FutureProvider.autoDispose.family<EmployeeEntity?, String>((ref, id) async {
  if (id == 'new') return null;
  final result = await ref.watch(employeeRepositoryProvider).getById(id);
  return result.fold((_) => null, (e) => e);
});

class EmployeeDetailScreen extends ConsumerStatefulWidget {
  const EmployeeDetailScreen({required this.employeeId, super.key});

  final String employeeId;

  @override
  ConsumerState<EmployeeDetailScreen> createState() =>
      _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends ConsumerState<EmployeeDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;
  bool _filled = false;

  // Identity
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _fatherName = TextEditingController();
  final _nationalId = TextEditingController();
  final _birthDate = TextEditingController();
  final _birthPlace = TextEditingController();
  final _childrenCount = TextEditingController(text: '0');
  final _personalDescription = TextEditingController();
  String? _gender;
  String? _maritalStatus;
  String? _bloodGroup;
  String? _militaryStatus;

  // Contact
  final _primaryPhone = TextEditingController();
  final _secondaryPhone = TextEditingController();
  final _emergencyPhone = TextEditingController();
  final _email = TextEditingController();
  final _address = TextEditingController();
  final _postalCode = TextEditingController();

  // Social
  final _telegram = TextEditingController();
  final _whatsapp = TextEditingController();
  final _instagram = TextEditingController();
  final _linkedin = TextEditingController();

  // Organization
  final _employeeNumber = TextEditingController();
  final _subscriptionNumber = TextEditingController();
  final _currentPosition = TextEditingController();
  final _previousPosition = TextEditingController();
  final _desiredPosition = TextEditingController();
  final _employmentType = TextEditingController();
  final _employmentDate = TextEditingController();
  String _employmentStatus = 'active';

  // Education / skill quick notes (MVP single fields → full lists later)
  final _educationLevel = TextEditingController();
  final _major = TextEditingController();
  final _university = TextEditingController();
  final _skillName = TextEditingController();
  final _skillLevel = TextEditingController();

  // Insurance / evaluation
  final _insuranceNumber = TextEditingController();
  final _insuranceType = TextEditingController();
  final _evaluationScore = TextEditingController();
  final _evaluator = TextEditingController();
  final _strengths = TextEditingController();
  final _weaknesses = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    for (final c in [
      _firstName,
      _lastName,
      _fatherName,
      _nationalId,
      _birthDate,
      _birthPlace,
      _childrenCount,
      _personalDescription,
      _primaryPhone,
      _secondaryPhone,
      _emergencyPhone,
      _email,
      _address,
      _postalCode,
      _telegram,
      _whatsapp,
      _instagram,
      _linkedin,
      _employeeNumber,
      _subscriptionNumber,
      _currentPosition,
      _previousPosition,
      _desiredPosition,
      _employmentType,
      _employmentDate,
      _educationLevel,
      _major,
      _university,
      _skillName,
      _skillLevel,
      _insuranceNumber,
      _insuranceType,
      _evaluationScore,
      _evaluator,
      _strengths,
      _weaknesses,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _fill(EmployeeEntity e) {
    _firstName.text = e.firstName;
    _lastName.text = e.lastName;
    _fatherName.text = e.fatherName ?? '';
    _nationalId.text = e.nationalId;
    _birthDate.text = e.birthDate ?? '';
    _birthPlace.text = e.birthPlace ?? '';
    _childrenCount.text = '${e.childrenCount}';
    _personalDescription.text = e.personalDescription ?? '';
    _gender = e.gender;
    _maritalStatus = e.maritalStatus;
    _bloodGroup = e.bloodGroup;
    _militaryStatus = e.militaryStatus;
    _primaryPhone.text = e.contact?.primaryPhone ?? '';
    _secondaryPhone.text = e.contact?.secondaryPhone ?? '';
    _emergencyPhone.text = e.contact?.emergencyPhone ?? '';
    _email.text = e.contact?.email ?? '';
    _address.text = e.contact?.homeAddress ?? '';
    _postalCode.text = e.contact?.postalCode ?? '';
    _telegram.text = e.social?.telegram ?? '';
    _whatsapp.text = e.social?.whatsapp ?? '';
    _instagram.text = e.social?.instagram ?? '';
    _linkedin.text = e.social?.linkedin ?? '';
    _employeeNumber.text = e.employeeNumber ?? '';
    _subscriptionNumber.text = e.subscriptionNumber ?? '';
    _currentPosition.text = e.currentPosition ?? '';
    _previousPosition.text = e.previousPosition ?? '';
    _desiredPosition.text = e.desiredPosition ?? '';
    _employmentType.text = e.employmentType ?? '';
    _employmentDate.text = e.employmentDate ?? '';
    _employmentStatus = e.employmentStatus;
    if (e.educations.isNotEmpty) {
      _educationLevel.text = e.educations.first.educationLevel ?? '';
      _major.text = e.educations.first.major ?? '';
      _university.text = e.educations.first.university ?? '';
    }
    if (e.skills.isNotEmpty) {
      _skillName.text = e.skills.first.skillName;
      _skillLevel.text = e.skills.first.level ?? '';
    }
    if (e.insurances.isNotEmpty) {
      _insuranceNumber.text = e.insurances.first.insuranceNumber ?? '';
      _insuranceType.text = e.insurances.first.insuranceType ?? '';
    }
    if (e.evaluations.isNotEmpty) {
      _evaluationScore.text = '${e.evaluations.first.score ?? ''}';
      _evaluator.text = e.evaluations.first.evaluator ?? '';
      _strengths.text = e.evaluations.first.strengths ?? '';
      _weaknesses.text = e.evaluations.first.weaknesses ?? '';
    }
  }

  EmployeeEntity _buildEntity() {
    final isNew = widget.employeeId == 'new';
    return EmployeeEntity(
      id: isNew ? '' : widget.employeeId,
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      fatherName: _emptyToNull(_fatherName),
      nationalId: _nationalId.text.trim(),
      birthDate: _emptyToNull(_birthDate),
      birthPlace: _emptyToNull(_birthPlace),
      gender: _gender,
      maritalStatus: _maritalStatus,
      childrenCount: int.tryParse(_childrenCount.text.trim()) ?? 0,
      bloodGroup: _bloodGroup,
      militaryStatus: _militaryStatus,
      personalDescription: _emptyToNull(_personalDescription),
      employeeNumber: _emptyToNull(_employeeNumber),
      subscriptionNumber: _emptyToNull(_subscriptionNumber),
      currentPosition: _emptyToNull(_currentPosition),
      previousPosition: _emptyToNull(_previousPosition),
      desiredPosition: _emptyToNull(_desiredPosition),
      employmentType: _emptyToNull(_employmentType),
      employmentDate: _emptyToNull(_employmentDate),
      employmentStatus: _employmentStatus,
      contact: ContactInfo(
        primaryPhone: _emptyToNull(_primaryPhone),
        secondaryPhone: _emptyToNull(_secondaryPhone),
        emergencyPhone: _emptyToNull(_emergencyPhone),
        email: _emptyToNull(_email),
        homeAddress: _emptyToNull(_address),
        postalCode: _emptyToNull(_postalCode),
      ),
      social: SocialInfo(
        telegram: _emptyToNull(_telegram),
        whatsapp: _emptyToNull(_whatsapp),
        instagram: _emptyToNull(_instagram),
        linkedin: _emptyToNull(_linkedin),
      ),
    );
  }

  String? _emptyToNull(TextEditingController c) {
    final v = c.text.trim();
    return v.isEmpty ? null : v;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      _tabs.animateTo(0);
      return;
    }
    setState(() => _saving = true);
    final entity = _buildEntity();
    final repo = ref.read(employeeRepositoryProvider);
    final result = widget.employeeId == 'new'
        ? await CreateEmployeeUseCase(repo)(entity)
        : await UpdateEmployeeUseCase(repo)(entity);

    if (!mounted) return;
    setState(() => _saving = false);

    result.fold(
      (f) {
        final detail = f is ValidationFailure && f.fieldErrors.isNotEmpty
            ? f.fieldErrors.values.join(' — ')
            : f.message;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(detail)),
        );
      },
      (saved) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('اطلاعات کارمند ذخیره شد')),
        );
        ref.invalidate(employeeListProvider);
        if (widget.employeeId == 'new') {
          context.go('/employees/${saved.id}');
        } else {
          ref.invalidate(employeeDetailProvider(widget.employeeId));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncEmp = ref.watch(employeeDetailProvider(widget.employeeId));
    final isNew = widget.employeeId == 'new';

    return asyncEmp.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (employee) {
        if (employee != null && !_filled) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!_filled) {
              _fill(employee);
              setState(() => _filled = true);
            }
          });
        }

        final narrow = context.isNarrow;
        final canEdit = hasSessionPermission(
          ref,
          isNew
              ? PermissionCodes.employeesCreate
              : PermissionCodes.employeesEdit,
        );
        final canImport =
            hasSessionPermission(ref, PermissionCodes.employeesImport);

        return Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(context.isNarrow ? GazSpacing.md : GazSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (narrow)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => context.go('/employees'),
                            icon: const Icon(Icons.arrow_forward),
                          ),
                          Expanded(
                            child: Text(
                              isNew
                                  ? 'ثبت کارمند جدید'
                                  : (employee?.fullName ?? 'جزئیات کارمند'),
                              style: Theme.of(context).textTheme.titleLarge,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.end,
                        children: [
                          if (isNew && canImport)
                            OutlinedButton.icon(
                              onPressed: () => context.go('/employees/import'),
                              icon: const Icon(Icons.group_add_outlined),
                              label: const Text('ورود گروهی'),
                            ),
                          if (canEdit)
                            FilledButton.icon(
                              onPressed: _saving ? null : _save,
                              icon: _saving
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.save_outlined),
                              label: Text(_saving ? '...' : 'ذخیره'),
                            ),
                        ],
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.go('/employees'),
                        icon: const Icon(Icons.arrow_forward),
                      ),
                      Expanded(
                        child: Text(
                          isNew
                              ? 'ثبت کارمند جدید'
                              : (employee?.fullName ?? 'جزئیات کارمند'),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      if (isNew && canImport)
                        OutlinedButton.icon(
                          onPressed: () => context.go('/employees/import'),
                          icon: const Icon(Icons.group_add_outlined),
                          label: const Text('ورود گروهی'),
                        ),
                      if (canEdit) ...[
                        if (isNew && canImport) const SizedBox(width: 8),
                        FilledButton.icon(
                          onPressed: _saving ? null : _save,
                          icon: _saving
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.save_outlined),
                          label: Text(_saving ? '...' : 'ذخیره'),
                        ),
                      ],
                    ],
                  ),
                GazTabBar(
                  controller: _tabs,
                  tabs: const [
                    Tab(text: 'هویت'),
                    Tab(text: 'تماس و شبکه‌ها'),
                    Tab(text: 'سازمان'),
                    Tab(text: 'تحصیلات و مهارت'),
                    Tab(text: 'بیمه و ارزیابی'),
                    Tab(text: 'اسناد'),
                  ],
                ),
                const SizedBox(height: GazSpacing.md),
                Expanded(
                  child: TabBarView(
                    controller: _tabs,
                    children: [
                      _IdentityTab(
                        firstName: _firstName,
                        lastName: _lastName,
                        fatherName: _fatherName,
                        nationalId: _nationalId,
                        birthDate: _birthDate,
                        birthPlace: _birthPlace,
                        childrenCount: _childrenCount,
                        personalDescription: _personalDescription,
                        gender: _gender,
                        maritalStatus: _maritalStatus,
                        bloodGroup: _bloodGroup,
                        militaryStatus: _militaryStatus,
                        onGender: (v) => setState(() => _gender = v),
                        onMarital: (v) => setState(() => _maritalStatus = v),
                        onBlood: (v) => setState(() => _bloodGroup = v),
                        onMilitary: (v) => setState(() => _militaryStatus = v),
                      ),
                      _ContactSocialTab(
                        primaryPhone: _primaryPhone,
                        secondaryPhone: _secondaryPhone,
                        emergencyPhone: _emergencyPhone,
                        email: _email,
                        address: _address,
                        postalCode: _postalCode,
                        telegram: _telegram,
                        whatsapp: _whatsapp,
                        instagram: _instagram,
                        linkedin: _linkedin,
                      ),
                      _OrgTab(
                        employeeNumber: _employeeNumber,
                        subscriptionNumber: _subscriptionNumber,
                        currentPosition: _currentPosition,
                        previousPosition: _previousPosition,
                        desiredPosition: _desiredPosition,
                        employmentType: _employmentType,
                        employmentDate: _employmentDate,
                        employmentStatus: _employmentStatus,
                        onStatus: (v) =>
                            setState(() => _employmentStatus = v),
                      ),
                      _EducationSkillTab(
                        educationLevel: _educationLevel,
                        major: _major,
                        university: _university,
                        skillName: _skillName,
                        skillLevel: _skillLevel,
                      ),
                      _InsuranceEvalTab(
                        insuranceNumber: _insuranceNumber,
                        insuranceType: _insuranceType,
                        evaluationScore: _evaluationScore,
                        evaluator: _evaluator,
                        strengths: _strengths,
                        weaknesses: _weaknesses,
                      ),
                      EmployeeDocumentsTab(employeeId: widget.employeeId),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(GazSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: GazSpacing.md),
            child,
          ],
        ),
      ),
    );
  }
}

Widget _field(
  TextEditingController c,
  String label, {
  TextInputType? keyboard,
  int maxLines = 1,
  String? Function(String?)? validator,
  List<TextInputFormatter>? formatters,
  bool required = false,
}) {
  return TextFormField(
    controller: c,
    keyboardType: keyboard,
    maxLines: maxLines,
    inputFormatters: formatters,
    validator: validator ??
        (required
            ? (v) => (v == null || v.trim().isEmpty) ? 'الزامی' : null
            : null),
    decoration: InputDecoration(
      labelText: required ? '$label *' : label,
    ),
  );
}

/// Responsive 1/2-column field layout without fixed aspect ratios (no overflow).
class _FieldGrid extends StatelessWidget {
  const _FieldGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 700;
        final gap = GazSpacing.md;
        final itemWidth =
            wide ? (constraints.maxWidth - gap) / 2 : constraints.maxWidth;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final child in children)
              SizedBox(width: itemWidth, child: child),
          ],
        );
      },
    );
  }
}


class _IdentityTab extends StatelessWidget {
  const _IdentityTab({
    required this.firstName,
    required this.lastName,
    required this.fatherName,
    required this.nationalId,
    required this.birthDate,
    required this.birthPlace,
    required this.childrenCount,
    required this.personalDescription,
    required this.gender,
    required this.maritalStatus,
    required this.bloodGroup,
    required this.militaryStatus,
    required this.onGender,
    required this.onMarital,
    required this.onBlood,
    required this.onMilitary,
  });

  final TextEditingController firstName;
  final TextEditingController lastName;
  final TextEditingController fatherName;
  final TextEditingController nationalId;
  final TextEditingController birthDate;
  final TextEditingController birthPlace;
  final TextEditingController childrenCount;
  final TextEditingController personalDescription;
  final String? gender;
  final String? maritalStatus;
  final String? bloodGroup;
  final String? militaryStatus;
  final ValueChanged<String?> onGender;
  final ValueChanged<String?> onMarital;
  final ValueChanged<String?> onBlood;
  final ValueChanged<String?> onMilitary;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _SectionCard(
          title: 'اطلاعات هویتی',
          child: _FieldGrid(
            children: [
              _field(firstName, 'نام', required: true),
              _field(lastName, 'نام خانوادگی', required: true),
              _field(fatherName, 'نام پدر'),
              _field(
                nationalId,
                'کد ملی',
                required: true,
                keyboard: TextInputType.number,
                formatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'الزامی';
                  if (!IranianNationalId.isValid(v)) return 'کد ملی نامعتبر';
                  return null;
                },
              ),
              GazJalaliDateField(controller: birthDate, label: 'تاریخ تولد'),
              _field(birthPlace, 'محل تولد'),
              DropdownButtonFormField<String>(
                value: gender,
                decoration: const InputDecoration(labelText: 'جنسیت'),
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('مرد')),
                  DropdownMenuItem(value: 'female', child: Text('زن')),
                ],
                onChanged: onGender,
              ),
              DropdownButtonFormField<String>(
                value: maritalStatus,
                decoration: const InputDecoration(labelText: 'وضعیت تأهل'),
                items: const [
                  DropdownMenuItem(value: 'single', child: Text('مجرد')),
                  DropdownMenuItem(value: 'married', child: Text('متأهل')),
                ],
                onChanged: onMarital,
              ),
              _field(
                childrenCount,
                'تعداد فرزندان',
                keyboard: TextInputType.number,
                formatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              DropdownButtonFormField<String>(
                value: bloodGroup,
                decoration: const InputDecoration(labelText: 'گروه خونی'),
                items: [
                  for (final g in [
                    'A+',
                    'A-',
                    'B+',
                    'B-',
                    'AB+',
                    'AB-',
                    'O+',
                    'O-',
                  ])
                    DropdownMenuItem(value: g, child: Text(g)),
                ],
                onChanged: onBlood,
              ),
              DropdownButtonFormField<String>(
                value: militaryStatus,
                decoration: const InputDecoration(labelText: 'وضعیت نظام وظیفه'),
                items: const [
                  DropdownMenuItem(value: 'done', child: Text('پایان خدمت')),
                  DropdownMenuItem(value: 'exempt', child: Text('معاف')),
                  DropdownMenuItem(value: 'serving', child: Text('در حال خدمت')),
                  DropdownMenuItem(
                    value: 'not_applicable',
                    child: Text('مشمول نیست'),
                  ),
                ],
                onChanged: onMilitary,
              ),
            ],
          ),
        ),
        const SizedBox(height: GazSpacing.md),
        _SectionCard(
          title: 'توضیحات شخصی',
          child: _field(personalDescription, 'توضیحات', maxLines: 4),
        ),
      ],
    );
  }
}

class _ContactSocialTab extends StatelessWidget {
  const _ContactSocialTab({
    required this.primaryPhone,
    required this.secondaryPhone,
    required this.emergencyPhone,
    required this.email,
    required this.address,
    required this.postalCode,
    required this.telegram,
    required this.whatsapp,
    required this.instagram,
    required this.linkedin,
  });

  final TextEditingController primaryPhone;
  final TextEditingController secondaryPhone;
  final TextEditingController emergencyPhone;
  final TextEditingController email;
  final TextEditingController address;
  final TextEditingController postalCode;
  final TextEditingController telegram;
  final TextEditingController whatsapp;
  final TextEditingController instagram;
  final TextEditingController linkedin;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _SectionCard(
          title: 'اطلاعات تماس',
          child: _FieldGrid(
            children: [
              _field(primaryPhone, 'تلفن اصلی', keyboard: TextInputType.phone),
              _field(secondaryPhone, 'تلفن دوم', keyboard: TextInputType.phone),
              _field(emergencyPhone, 'تلفن اضطراری', keyboard: TextInputType.phone),
              _field(email, 'ایمیل', keyboard: TextInputType.emailAddress),
              _field(postalCode, 'کد پستی', keyboard: TextInputType.number),
              _field(address, 'آدرس منزل', maxLines: 2),
            ],
          ),
        ),
        const SizedBox(height: GazSpacing.md),
        _SectionCard(
          title: 'شبکه‌های اجتماعی',
          child: _FieldGrid(
            children: [
              _field(telegram, 'تلگرام'),
              _field(whatsapp, 'واتساپ'),
              _field(instagram, 'اینستاگرام'),
              _field(linkedin, 'لینکدین'),
            ],
          ),
        ),
      ],
    );
  }
}

class _OrgTab extends StatelessWidget {
  const _OrgTab({
    required this.employeeNumber,
    required this.subscriptionNumber,
    required this.currentPosition,
    required this.previousPosition,
    required this.desiredPosition,
    required this.employmentType,
    required this.employmentDate,
    required this.employmentStatus,
    required this.onStatus,
  });

  final TextEditingController employeeNumber;
  final TextEditingController subscriptionNumber;
  final TextEditingController currentPosition;
  final TextEditingController previousPosition;
  final TextEditingController desiredPosition;
  final TextEditingController employmentType;
  final TextEditingController employmentDate;
  final String employmentStatus;
  final ValueChanged<String> onStatus;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _SectionCard(
          title: 'اطلاعات سازمانی',
          child: _FieldGrid(
            children: [
              _field(employeeNumber, 'شماره پرسنلی'),
              _field(subscriptionNumber, 'شماره اشتراک'),
              _field(currentPosition, 'سمت فعلی'),
              _field(previousPosition, 'سمت قبلی'),
              _field(desiredPosition, 'سمت مورد علاقه'),
              _field(employmentType, 'نوع استخدام'),
              GazJalaliDateField(controller: employmentDate, label: 'تاریخ استخدام'),
              DropdownButtonFormField<String>(
                value: employmentStatus,
                decoration: const InputDecoration(labelText: 'وضعیت اشتغال'),
                items: const [
                  DropdownMenuItem(value: 'active', child: Text('فعال')),
                  DropdownMenuItem(value: 'leave', child: Text('مرخصی')),
                  DropdownMenuItem(value: 'mission', child: Text('مأموریت')),
                  DropdownMenuItem(value: 'terminated', child: Text('خاتمه')),
                ],
                onChanged: (v) {
                  if (v != null) onStatus(v);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EducationSkillTab extends StatelessWidget {
  const _EducationSkillTab({
    required this.educationLevel,
    required this.major,
    required this.university,
    required this.skillName,
    required this.skillLevel,
  });

  final TextEditingController educationLevel;
  final TextEditingController major;
  final TextEditingController university;
  final TextEditingController skillName;
  final TextEditingController skillLevel;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _SectionCard(
          title: 'تحصیلات',
          child: _FieldGrid(
            children: [
              _field(educationLevel, 'مقطع تحصیلی'),
              _field(major, 'رشته'),
              _field(university, 'دانشگاه'),
            ],
          ),
        ),
        const SizedBox(height: GazSpacing.md),
        _SectionCard(
          title: 'مهارت اصلی',
          child: _FieldGrid(
            children: [
              _field(skillName, 'نام مهارت'),
              _field(skillLevel, 'سطح مهارت'),
            ],
          ),
        ),
      ],
    );
  }
}

class _InsuranceEvalTab extends StatelessWidget {
  const _InsuranceEvalTab({
    required this.insuranceNumber,
    required this.insuranceType,
    required this.evaluationScore,
    required this.evaluator,
    required this.strengths,
    required this.weaknesses,
  });

  final TextEditingController insuranceNumber;
  final TextEditingController insuranceType;
  final TextEditingController evaluationScore;
  final TextEditingController evaluator;
  final TextEditingController strengths;
  final TextEditingController weaknesses;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _SectionCard(
          title: 'بیمه',
          child: _FieldGrid(
            children: [
              _field(insuranceNumber, 'شماره بیمه'),
              _field(insuranceType, 'نوع بیمه'),
            ],
          ),
        ),
        const SizedBox(height: GazSpacing.md),
        _SectionCard(
          title: 'آخرین ارزیابی',
          child: Column(
            children: [
              _FieldGrid(
                children: [
                  _field(evaluationScore, 'امتیاز'),
                  _field(evaluator, 'ارزیاب'),
                ],
              ),
              const SizedBox(height: GazSpacing.md),
              _field(strengths, 'نقاط قوت', maxLines: 3),
              const SizedBox(height: GazSpacing.md),
              _field(weaknesses, 'نقاط ضعف', maxLines: 3),
            ],
          ),
        ),
      ],
    );
  }
}
