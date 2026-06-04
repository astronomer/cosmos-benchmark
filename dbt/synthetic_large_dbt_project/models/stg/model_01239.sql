{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00707') }},
        {{ ref('model_00081') }}
)
select id, 'model_01239' as name from sources
