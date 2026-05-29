{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01469') }},
        {{ ref('model_01205') }},
        {{ ref('model_01246') }}
)
select id, 'model_01508' as name from sources
