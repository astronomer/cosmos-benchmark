{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01066') }}
)
select id, 'model_01909' as name from sources
