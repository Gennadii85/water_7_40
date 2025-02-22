import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_7_40/presentation/cubit/add_address/add_address_cubit.dart';
import 'package:water_7_40/presentation/pages/admin/admin_buttons.dart';
import 'package:water_7_40/presentation/pages/admin/admin_drawer.dart';
import '../../../data/model/address_model.dart';
import '../../../data/model/users_registration_model.dart';
import '../../../data/model/write_address_model.dart';
import '../../../data/repositories/admin/admin_manager_report_repo.dart';
import '../../../data/repositories/admin/admin_page_manager_repo.dart';

class AdminAddAddress extends StatefulWidget {
  const AdminAddAddress({super.key});

  @override
  State<AdminAddAddress> createState() => _AdminAddAddressState();
}

class _AdminAddAddressState extends State<AdminAddAddress> {
  final TextEditingController houseControl = TextEditingController();
  final TextEditingController apartmentControl = TextEditingController();
  final TextEditingController managerIDControl = TextEditingController();

  @override
  void dispose() {
    houseControl.dispose();
    apartmentControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Добавить адрес'),
          centerTitle: true,
        ),
        drawer: const AdminDrawer(),
        body: SingleChildScrollView(
          child: StreamBuilder<List<CityModel>>(
            stream: RepoAdminGetPost().getCityAddress(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<CityModel> data = snapshot.data!;
                return FutureBuilder<List<UsersRegistrationModel>>(
                  future: RepoAdminGetPost().getAllManagers(),
                  builder: (context, snapshotManager) {
                    if (snapshotManager.hasData) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BlocProvider(
                          create: (context) {
                            return AddAddressCubit(data);
                          },
                          child: bodyPage(context, snapshotManager),
                        ),
                      );
                    } else if (snapshotManager.hasError) {
                      return const Center(
                        child: Text('Не удалось получить список менеджеров.'),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Не удалось получить список адресов.'),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }

  Column bodyPage(
    BuildContext context,
    AsyncSnapshot<List<UsersRegistrationModel>> snapshotManager,
  ) {
    return Column(
      children: [
        const Text('Населенный пункт *'),
        autocompleteCity(),
        const SizedBox(height: 20),
        const Text('Улица *'),
        autocompleteStreet(),
        const SizedBox(height: 20),
        BlocBuilder<AddAddressCubit, AddAddressState>(
          builder: (context, state) {
            return AdminButtons(
              text: 'Сохранить только адрес',
              function: () {
                if (state.city.isNotEmpty && state.street.isNotEmpty) {
                  RepoAdminGetPost().saveAddress(state.city, state.street);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AdminAddAddress(),
                    ),
                  );
                }
              },
            );
          },
        ),
        const SizedBox(height: 35),
        const Text(
          'Можно сразу прикрепить к адресу менеджера !!!  ',
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: houseControl,
                decoration: InputDecoration(
                  labelText: '№ дома',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: TextField(
                controller: apartmentControl,
                decoration: InputDecoration(
                  labelText: '№ квартиры',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextField(
          controller: managerIDControl,
          decoration: InputDecoration(
            labelText: 'ID менеджера - только цифра *',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 20),
        BlocBuilder<AddAddressCubit, AddAddressState>(
          builder: (context, state) {
            return AdminButtons(
              text: 'Сохранить адрес и прикрепить менеджера',
              function: () {
                if (state.city.isNotEmpty &&
                    state.street.isNotEmpty &&
                    houseControl.text.isNotEmpty &&
                    apartmentControl.text.isNotEmpty &&
                    managerIDControl.text.isNotEmpty) {
                  RepoAdminGetPost().saveAddressAndManager(
                    state.city,
                    state.street,
                    houseControl.text,
                    apartmentControl.text,
                    managerIDControl.text,
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AdminAddAddress(),
                    ),
                  );
                }
              },
            );
          },
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Если нужно сменить менеджера на адресе - просто выберите нужный адрес и назначьте новый ID менеджера!',
          ),
        ),
        const SizedBox(height: 30),
        AdminButtons(
          text: 'Просмотреть все закрепленные адреса',
          function: () => showDialog(
            context: context,
            builder: (context) => showAllWriteAddress(snapshotManager),
          ),
        ),
      ],
    );
  }

  Scaffold showAllWriteAddress(
    AsyncSnapshot<List<UsersRegistrationModel>> snapshotManager,
  ) {
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder<List<WriteAddressModel>>(
          stream: RepoAdminManagersReport().getAllWriteAddress(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              Set<String> setData = {};
              for (var element in data) {
                setData.add(element.id);
              }
              List<String> listData = setData.toList();
              return Column(
                children: [
                  ListView.builder(
                    itemCount: setData.length,
                    shrinkWrap: true,
                    itemBuilder: ((context, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(border: Border.all()),
                            child: ExpansionTile(
                              childrenPadding: const EdgeInsets.all(5),
                              title: Row(
                                children: [
                                  Text('ID: ${listData[index]}'),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Text(
                                      snapshotManager.data!
                                              .where(
                                                (element) =>
                                                    element.id.toString() ==
                                                    listData[index],
                                              )
                                              .isNotEmpty
                                          ? snapshotManager.data!
                                                  .where(
                                                    (element) =>
                                                        element.id.toString() ==
                                                        listData[index],
                                                  )
                                                  .first
                                                  .nickname ??
                                              'Нет данных'
                                          : 'Нет данных',
                                    ),
                                  ),
                                ],
                              ),
                              children: data
                                  .where(
                                    (element) => element.id == listData[index],
                                  )
                                  .map(
                                    (elem) => Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              elem.address,
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Text(elem.phone ?? ''),
                                                Text(elem.name ?? ''),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        )),
                  ),
                  const SizedBox(height: 30),
                  AdminButtons(
                    text: 'Выйти',
                    function: () => Navigator.of(context).pop(),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Не удалось получить список всех закрепленных адресов.',
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Container autocompleteCity() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocBuilder<AddAddressCubit, AddAddressState>(
          builder: (context, state) {
            final cubit = BlocProvider.of<AddAddressCubit>(context);
            return Row(
              children: [
                Expanded(
                  child: Autocomplete<String>(
                    optionsMaxHeight: 600,
                    optionsBuilder: (textEditingValue) {
                      state.city = textEditingValue.text;
                      return state.cityList
                          .map((e) => e.toLowerCase())
                          .toList()
                          .where((option) {
                        return option
                            .contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (selection) {
                      state.city = selection;
                      cubit.addCity();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Container autocompleteStreet() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocBuilder<AddAddressCubit, AddAddressState>(
          builder: (context, state) {
            // final cubit = BlocProvider.of<AddAddressCubit>(context);
            return Row(
              children: [
                Expanded(
                  child: Autocomplete<String>(
                    optionsMaxHeight: 600,
                    optionsBuilder: (textEditingValue) {
                      state.street = textEditingValue.text;
                      return state.streetList
                          .map((e) => e.toLowerCase())
                          .toList()
                          .where((option) {
                        return option
                            .contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (selection) {
                      state.street = selection;
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
