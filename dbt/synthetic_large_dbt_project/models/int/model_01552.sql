{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01020') }},
        {{ ref('model_01348') }}
)
select id, 'model_01552' as name from sources
