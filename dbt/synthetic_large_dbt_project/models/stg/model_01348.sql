{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00200') }},
        {{ ref('model_00023') }}
)
select id, 'model_01348' as name from sources
