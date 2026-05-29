{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02140') }},
        {{ ref('model_01983') }},
        {{ ref('model_02200') }}
)
select id, 'model_02324' as name from sources
