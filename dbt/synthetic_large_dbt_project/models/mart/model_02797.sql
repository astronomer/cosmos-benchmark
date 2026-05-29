{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01909') }},
        {{ ref('model_01929') }}
)
select id, 'model_02797' as name from sources
