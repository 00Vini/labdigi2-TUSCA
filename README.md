# Rodar com Waveform

Antes de criar o arquivo `wave.do`:

```
vlog *.v
vsim work.top_level_tb -voptargs=+acc -do "run -all"
```

Depois de salvar um arquivo `wave.do`:

```
vlog *.v
vsim work.top_level_tb -voptargs=+acc -do "do wave.do; run -all"
```

# Rodar sem Waveform

```
vlog *.v
vsim -c work.top_level_tb -voptargs=+acc -do "run -all; q"
```
