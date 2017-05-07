﻿#include <benchmark/benchmark.h>
#include <matazure/tensor>

using namespace matazure;

template <typename _ValueType>
void bm_cu_prod(benchmark::State& state) {
	pointi<2> ext;
	fill(ext, state.range(0));

	cuda::matrix<_ValueType> ts_lhs(ext);
	cuda::matrix<_ValueType> ts_rhs(ext);

	cuda::matrix<_ValueType> ts_re(ext);
	while (state.KeepRunning()) {
		copy(numeric::prod_general(ts_lhs, ts_rhs), ts_re);
		cuda::device_synchronize();
	}
	
	state.SetBytesProcessed(ts_lhs.size() * sizeof(decltype(ts_lhs[0])) + ts_rhs.size() * sizeof(decltype(ts_rhs[0])) + ts_re.size() * sizeof(decltype(ts_re[0])));
	state.SetItemsProcessed(static_cast<size_t>(2 * ts_lhs.shape()[0] * ts_lhs.shape()[1]) * ts_rhs.shape()[1]);
}
BENCHMARK_TEMPLATE1(bm_cu_prod, float)->RangeMultiplier(2)->Range(1 << 10, 1 << 12)->UseRealTime();
BENCHMARK_TEMPLATE1(bm_cu_prod, double)->RangeMultiplier(2)->Range(1 << 10, 1 << 11)->UseRealTime();

template <typename _ValueType>
void bm_prod(benchmark::State& state) {
	pointi<2> ext;
	fill(ext, state.range(0));

	matrix<_ValueType> ts_lhs(ext);
	matrix<_ValueType> ts_rhs(ext);

	matrix<_ValueType> ts_re(ext);
	while (state.KeepRunning()) {
		copy(numeric::prod_general(ts_lhs, ts_rhs), ts_re);
	}
	
	state.SetBytesProcessed(ts_lhs.size() * sizeof(decltype(ts_lhs[0])) + ts_rhs.size() * sizeof(decltype(ts_rhs[0])) + ts_re.size() * sizeof(decltype(ts_re[0])));
	state.SetItemsProcessed(static_cast<size_t>(2 * ts_lhs.shape()[0] * ts_lhs.shape()[1]) * ts_rhs.shape()[1]);
}
BENCHMARK_TEMPLATE1(bm_prod, float)->RangeMultiplier(2)->Range(1 << 10, 1 << 10)->UseRealTime();
BENCHMARK_TEMPLATE1(bm_prod, double)->RangeMultiplier(2)->Range(1 << 10, 1 << 10)->UseRealTime();




