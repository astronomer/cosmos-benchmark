{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00775') }},
        {{ ref('model_00933') }}
)
select id, 'model_01648' as name from sources
