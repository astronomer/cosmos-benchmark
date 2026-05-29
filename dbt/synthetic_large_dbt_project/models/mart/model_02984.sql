{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01611') }},
        {{ ref('model_01997') }},
        {{ ref('model_02141') }}
)
select id, 'model_02984' as name from sources
