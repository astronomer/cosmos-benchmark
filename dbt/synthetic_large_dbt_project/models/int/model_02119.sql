{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01295') }},
        {{ ref('model_00803') }}
)
select id, 'model_02119' as name from sources
