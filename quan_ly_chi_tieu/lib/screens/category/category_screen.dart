import 'package:base_project/screens/base_screen.dart';
import 'package:base_project/screens/home/component/category_icon.dart';
import 'package:base_project/utils/commons/globals.dart';
import 'package:base_project/utils/databases/database_manager.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key, required this.type});
  final int type;
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController())..changeTypeCategory(type);
    return BaseScreen(
      showBackButton: true,
      showMenuButton: true,
      title: 'category.title',
      keyRoute: 'category',
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const SizedBox(height: 14),
            Obx(() => CustomSegmented(
              listButtonTitle: const [
                'home.segmented.income',
                'home.segmented.expense',
              ],
              initIndex: controller.typeCategory.value,
              didSelectedIndex: (int index) {
                controller.changeTypeCategory(index);
              },
            )),
            const SizedBox(height: 20),
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if(controller.typeTransactions.value == Global.EXPENSES)
                const CustomLabel(
                  title: 'category.cost.fixed',
                  textAlign: TextAlign.start,
                  customTextStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ],
            )),
            Obx(() => Column(
              children: [
                for (int i = 0; i <= controller.listCategoryFixeds.length; i += 3)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 300,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (controller.listCategoryFixeds.length > i)
                              GestureDetector(
                                onTap: () {
                                  controller.changeToTransactionByCategory(controller.listCategoryFixeds[i].id);
                                },
                                child: itemCategoryWidget(controller.listCategoryFixeds[i]),
                              ),
                              if (controller.listCategoryFixeds.length > i)
                              const SizedBox(width: 45),
                              if (controller.listCategoryFixeds.length > i + 1)
                              GestureDetector(
                                onTap: () {
                                  controller.changeToTransactionByCategory(controller.listCategoryFixeds[i + 1].id);
                                },
                                child: itemCategoryWidget(controller.listCategoryFixeds[i + 1])
                              ),
                              if (controller.listCategoryFixeds.length > i + 1)
                              const SizedBox(width: 45),
                              if (controller.listCategoryFixeds.length > i + 2)
                              GestureDetector(
                                onTap: () {
                                  controller.changeToTransactionByCategory(controller.listCategoryFixeds[i + 2].id);
                                },
                                child: itemCategoryWidget(controller.listCategoryFixeds[i + 2]),
                              ),
                              if ((controller.listCategoryFixeds.length >= i) && (controller.listCategoryFixeds.length < i + 3))
                              Container(
                                padding: const EdgeInsets.all(2),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        controller.changeToAddCategory(Global.TYPE_FIXED);
                                      },
                                      child: Image.asset(AppImages.ic_create, width: 60, fit: BoxFit.fitWidth),
                                    ),
                                    const CustomLabel(title: 'category.create')
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            )),
            const SizedBox(height: 10),
            Obx(() => Column(
              children: [
                if(controller.typeTransactions.value == Global.EXPENSES)
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomLabel(
                      title: 'category.cost.extra',
                      customTextStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ],
                ),
                if(controller.typeTransactions.value == Global.EXPENSES)
                Column(
                  children: [
                    for (int i = 0; i <= controller.listCategoryExtras.length; i += 3)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 300,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (controller.listCategoryExtras.length > i)
                                  GestureDetector(
                                    onTap: () {
                                      controller.changeToTransactionByCategory(controller.listCategoryExtras[i].id);
                                    },
                                    child: itemCategoryWidget(controller.listCategoryExtras[i]),
                                  ),
                                  if (controller.listCategoryExtras.length > i)
                                  const SizedBox(width: 45),
                                  if (controller.listCategoryExtras.length > i + 1)
                                  GestureDetector(
                                    onTap: () {
                                      controller.changeToTransactionByCategory(controller.listCategoryExtras[i + 1].id);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      child:itemCategoryWidget(controller.listCategoryExtras[i + 1]),
                                    ),
                                  ),
                                  if (controller.listCategoryExtras.length > i + 1)
                                  const SizedBox(width: 45),
                                  if (controller.listCategoryExtras.length > i + 2)
                                  GestureDetector(
                                    onTap: () {
                                      controller.changeToTransactionByCategory(controller.listCategoryExtras[i + 2].id);
                                    },
                                    child: itemCategoryWidget(controller.listCategoryExtras[i + 2]),
                                  ),
                                  if ((controller.listCategoryExtras.length >= i) && (controller.listCategoryExtras.length < i + 3))
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            controller.changeToAddCategory(Global.TYPE_EXTRA);
                                          },
                                          child: Image.asset(AppImages.ic_create, width: 60, fit: BoxFit.fitWidth),
                                        ),
                                        const CustomLabel(title: 'category.create')
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
    Widget itemCategoryWidget(CategoryModel category) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          CategoryIcon(
            width: 60,
            imageWidth: 47,
            imageName: category.icon,
            color: Color(int.parse(category.color)),
          ),
          SizedBox(
            width: 60,
            child: CustomLabel(
              title: category.name,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryController extends GetxController {
  static CategoryController get instance => Get.find();

  final TextEditingController phoneTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  var listCategoryFixeds = <CategoryModel>[].obs;
  var listCategoryExtras = <CategoryModel>[].obs;

  var categorySelect = 0.obs;
  var typeTransactions = ''.obs;
  var typeCategory = 0.obs;


  void validation(BuildContext context) async {
    _requestLogin(context);
  }

  void _requestLogin(BuildContext context) async {
    Get.to(() => const HomeScreen());
  }

  void changeCategorySelect(int type) {
    categorySelect.value = type;
  }

  void changeTypeCategory(int type) async {
    await Future.delayed(Duration.zero);
    typeCategory.value = type;
    if (type == 0) {
      typeTransactions.value = Global.INCOMES;
    } else {
      typeTransactions.value = Global.EXPENSES;
    }
    listCategoryFixeds.value = [];
    listCategoryExtras.value = [];
    listCategoriesData();
    categorySelect.value = 0;
  }
  // get list categories
  void listCategoriesData() async {
    var listCategories = <CategoryModel>[];
    if (typeTransactions.value == Global.INCOMES) {
      listCategories = await DatabaseManager.instance.getTypeIncomes();
    } else {
      listCategories = await DatabaseManager.instance.getTypeExpenses();
    }

    var listCategoryFixedsTemp = <CategoryModel>[];
    var listCategoryExtrasTemp = <CategoryModel>[];
    for (var category in listCategories) {
      if (category.type == Global.TYPE_FIXED) {
        listCategoryFixedsTemp.add(category);
      }
      if (category.type == Global.TYPE_EXTRA) {
        listCategoryExtrasTemp.add(category);
      }
    }
    listCategoryFixeds.value = listCategoryFixedsTemp;
    listCategoryExtras.value = listCategoryExtrasTemp;
  }

  void changeToTransactionByCategory(int categoryId) {
    Get.to(() => TransactionListCategoryScreen(typeCategory: typeCategory.value, categoryId: categoryId));
  }

  void changeToAddCategory(int typeFixed) {
    Get.to(() => CategoryAddScreen(typeCategory: typeCategory.value, typeFixed: typeFixed));
  }
}
