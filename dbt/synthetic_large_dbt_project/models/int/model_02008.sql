{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00996') }},
        {{ ref('model_01341') }},
        {{ ref('model_01239') }}
)
select id, 'model_02008' as name from sources
