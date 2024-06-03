import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter/material.dart';

class InApp extends StatefulWidget {
  const InApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _InAppState();
  }
}

class _InAppState extends State<InApp> {
  static const _productIds = {
    'product_1do',
    'product_2do',
    'product_3do',
    'product_5do',
    'product_7do',
    'product_10do',
    'product_20do'
  };
  final InAppPurchase _connection = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products = [];

  @override
  void initState() {
    super.initState();
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _connection.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      // handle error here.
    });
    initStoreInfo();
  }

  initStoreInfo() async {
    ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(_productIds);
    if (productDetailResponse.error == null) {
      setState(() {
        _products = productDetailResponse.productDetails;
        _products.sort((a, b) => a.rawPrice.compareTo(b.rawPrice));
      });
    }
  }

  _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // show progress bar or something
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // show error message or failure icon
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          // Global.buyedConsumable = true;
          Navigator.pop(context);
          // show success message and deliver the product.
        }
        if (purchaseDetails.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }

  @override
  void dispose() {
    // if (Platform.isIOS) {
    //   final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
    //       _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
    //   iosPlatformAddition.setDelegate(null);
    // }
    _subscription.cancel();
    super.dispose();
  }

  _buyProduct(ProductDetails item) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: item);
    _connection.buyConsumable(purchaseParam: purchaseParam);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Upgrade',
                style: TextStyle(
                  color: Color(0xffF46A05),
                  fontSize: 39,
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _products
                .map(
                  (item) => Column(
                    children: [
                      SizedBox(
                        width: 100,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            _buyProduct(item);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            shadowColor: Colors.brown.withOpacity(0.5),
                            elevation: 8,
                            side: const BorderSide(
                              color: Color(0xffFF6E04),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            item.price,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xffFF6E04)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                )
                .toList(),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Back'),
          )
        ],
      ),
    );
  }
}
