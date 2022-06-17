### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 6c77bbbe-3aaf-11eb-1da6-0f47bea47d36
begin
	using FFTW
	using DSP
	using Plots
	using FileIO
	using OffsetArrays
	using PlutoUI
	using WAV
end

# ╔═╡ 8a01ebc0-3aaf-11eb-3906-7fe1bf3fe2c7
A = wavread("chirp2.wav")[1];

# ╔═╡ cbf0adde-4679-11eb-3fac-cfb79925e47b
B = wavread("bg.wav")[1];

# ╔═╡ 42b09522-467c-11eb-24a3-7b25065379bb
synth = wavread("f1380-synth.wav")[1];

# ╔═╡ ce8561d2-3aaf-11eb-235f-6d06e64d819f
A_fft = fft(A);

# ╔═╡ d818f4a4-4679-11eb-1fae-4929efb215f3
B_fft = fft(B);

# ╔═╡ 7f6d1aa0-467c-11eb-2cf7-972b1de23ddc
synth_fft = fft(synth);

# ╔═╡ 2094dc5a-3ab0-11eb-1abb-f98deba2b75b
# [1:1:floor(Int, length(A_fft)/2)] .* (44100/length(A_fft))
begin
	plot([1:1:floor(Int, length(A_fft)/2)] .* (44100/length(A_fft)), abs.(A_fft)[1:1:floor(Int, length(A_fft)/2)])
	# plot!([1:1:floor(Int, length(B_fft)/2)] .* (44100/length(B_fft)), abs.(B_fft)[1:1:floor(Int, length(B_fft)/2)], label = "F = 1900g Hz")
	# plot!([1:1:floor(Int, length(synth_fft)/2)] .* (44100/length(synth_fft)), abs.(synth_fft)[1:1:floor(Int, length(synth_fft)/2)], label = "F = 1380s Hz")
	xlims!(1000, 15000); ylims!(0, 100);
end
# bar([50750:50800] .* (44100/length(A_fft)), abs.(A_fft)[50750:50800])

# ╔═╡ Cell order:
# ╠═6c77bbbe-3aaf-11eb-1da6-0f47bea47d36
# ╠═8a01ebc0-3aaf-11eb-3906-7fe1bf3fe2c7
# ╠═cbf0adde-4679-11eb-3fac-cfb79925e47b
# ╠═42b09522-467c-11eb-24a3-7b25065379bb
# ╠═ce8561d2-3aaf-11eb-235f-6d06e64d819f
# ╠═d818f4a4-4679-11eb-1fae-4929efb215f3
# ╠═7f6d1aa0-467c-11eb-2cf7-972b1de23ddc
# ╠═2094dc5a-3ab0-11eb-1abb-f98deba2b75b
