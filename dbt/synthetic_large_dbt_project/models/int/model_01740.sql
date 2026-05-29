{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01234') }},
        {{ ref('model_01095') }}
)
select id, 'model_01740' as name from sources
