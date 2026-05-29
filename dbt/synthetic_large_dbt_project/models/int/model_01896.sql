{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00858') }},
        {{ ref('model_01428') }},
        {{ ref('model_01345') }}
)
select id, 'model_01896' as name from sources
