{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00057') }},
        {{ ref('model_00682') }},
        {{ ref('model_00369') }}
)
select id, 'model_01350' as name from sources
