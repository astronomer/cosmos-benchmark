{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01999') }},
        {{ ref('model_02074') }},
        {{ ref('model_02121') }}
)
select id, 'model_02457' as name from sources
