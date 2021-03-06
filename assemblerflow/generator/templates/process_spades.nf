
process process_spades_{{ pid }} {

    // Send POST request to platform
    {% include "post.txt" ignore missing %}

    tag { sample_id }
    // This process can only use a single CPU
    cpus 1
    publishDir "reports/assembly/spades_filter_{{ pid }}", pattern: '*.report.csv', mode: 'copy'

    input:
    set sample_id, file(assembly) from {{ input_channel }}
    val opts from IN_process_spades_opts
    val gsize from IN_genome_size
    val assembler from Channel.value("spades")

    output:
    set sample_id, file('*.fasta') into {{ output_channel }}
    file '*.report.csv' optional true
    {% with task_name="process_spades" %}
    {%- include "compiler_channels.txt" ignore missing -%}
    {% endwith %}

    script:
    template "process_assembly.py"

}

{{ forks }}

