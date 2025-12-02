import '../../data/datasources/api_datasource.dart';
import '../../data/repositories/product_repository.dart';
import '../../domain/usecases/scrape_product_usecase.dart';
import '../../domain/usecases/post_everywhere_usecase.dart';
import '../../presentation/controllers/product_post_controller.dart';
import '../../presentation/controllers/simple_post_controller.dart';

class DependencyInjection {
  static late final IApiDataSource apiDataSource;
  static late final ProductRepository productRepository;
  static late final ScrapeProductUseCase scrapeProductUseCase;
  static late final PostEverywhereUseCase postEverywhereUseCase;
  static bool _initialized = false;

  static void init() {
    if (_initialized) return;
    apiDataSource = ApiDataSource();
    productRepository = ProductRepository(apiDataSource);
    scrapeProductUseCase = ScrapeProductUseCase(productRepository);
    postEverywhereUseCase = PostEverywhereUseCase(productRepository);
    _initialized = true;
  }

  static ProductPostController createProductPostController() {
    return ProductPostController(
      scrapeProductUseCase: scrapeProductUseCase,
      postEverywhereUseCase: postEverywhereUseCase,
    );
  }

  static SimplePostController createSimplePostController() {
    return SimplePostController(
      postEverywhereUseCase: postEverywhereUseCase,
    );
  }
}
