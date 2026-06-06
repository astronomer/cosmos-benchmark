{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01965') }},
        {{ ref('model_02174') }}
)
select id, 'model_02508' as name from sources
